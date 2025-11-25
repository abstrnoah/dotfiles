let
  keys.porcupine.root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPmx7THEsb9khRkKsRvP+H6YXWMELTrUTSqqJ9l5TBys";
  keys.porcupine.abstrnoah = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEZ9mQCEEAkDUxw/eXywPUD1WrVrOfVrdY/KZ6LTqwJk";
  keys.all = [
    keys.porcupine.root
    keys.porcupine.abstrnoah
  ];
in
{
  "networkmanager.age" = {
    publicKeys = keys.all;
    armor = true;
  };
}
