import UIKit

class PokemonViewController: UIViewController {
    var url: String!
    var caught: Bool = false
    var caughtPokemon: [String] = []
    var pokemonFlavor: [PokemonFlavor]!

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet weak var catchButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""

        loadPokemon()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

        UserDefaults.standard.set(caughtPokemon, forKey: "Pokemon")
    }

    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.capitalize(text: result.name)
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.numberLabel.text = String(format: "#%03d", result.id)
                    self.checkCaught()
                    self.getDescription(for: result.id)

                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                    let spriteUrl = result.sprites.front_default
                        self.getSprite(from: spriteUrl)
                    
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    func checkCaught() {
        caughtPokemon = UserDefaults.standard.stringArray(forKey: "Pokemon") ?? []
        for name in caughtPokemon {
            if name == nameLabel.text! {
                caught = true
                catchButton.setTitle("Release", for: .normal)
            }
        }
    }
    func getDescription(for number: Int) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon-species/" + String(number)) else
        {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
                   
            do {
                let entries = try JSONDecoder().decode(PokemonSpecies.self, from: data)
                DispatchQueue.main.async {
                    self.pokemonFlavor = entries.flavor_text_entries
                    for flavor in self.pokemonFlavor {
                        if flavor.language.name == "en" {
                            self.descriptionLabel.text = flavor.flavor_text
                            break
                        }
                    }
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    func getSprite(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.main.async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            let image = UIImage(data: imageData)
            self.imageView.image = image
        }
    }

    @IBAction func toogleCatch(_ sender: UIButton) {
        
        if caught == false {
            caught = true
            sender.setTitle("Release", for: .normal)
            caughtPokemon.append(nameLabel.text!)
        } else {
            caught = false
            sender.setTitle("Catch", for: .normal)
            if let index = caughtPokemon.firstIndex(of: nameLabel.text!) {
                caughtPokemon.remove(at: index)
            }
        }
    }
}
