module LoaderMacro
  module ExampleMethods
    def load_file(filename)
      File.new(File.expand_path("../files/#{filename}", __FILE__)).read
    end
    
    def load_params(filename)
      params = YandexKassaForm::Params.parse(load_file(filename))
    end
  end

  module ExampleGroupMethods
    def loader(name, filename)
      let(name.to_sym) { File.new(File.expand_path("../files/#{filename}", __FILE__)).read }
    end
  end

  def self.included(receiver)
    receiver.extend         ExampleGroupMethods
    receiver.send :include, ExampleMethods
  end
end
