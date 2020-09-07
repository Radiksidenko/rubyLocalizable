# ruby vars.rb

pathToLocalizableFile = 'Localizable.strings'
localizable_file = File.open(pathToLocalizableFile, "r")

localization_file = nil
currentEnum = nil
forbiddenNames = ["repeat", "continue", "default"]

localizable_file.each_line do |line|
  if line.include? "MARK"

    nameEnum = line.sub("// MARK: ", "").delete!("\n")

    if !currentEnum.nil? &&
      currentEnum != nameEnum

      localization_file.puts("\t }")
      localization_file.puts("}")
    end

    currentEnum = nameEnum
    localization_file = File.new("Localization/Localization+#{nameEnum}.swift", "w")
    localization_file.puts("//  Localization+#{nameEnum}.swift")
    localization_file.puts("extension Localization {")
    newLine = "\n\t enum #{nameEnum}: LocalizationCase {"
    localization_file.puts(newLine)

  else

    if !currentEnum.nil?
      sub = "\"" + currentEnum.to_s.downcase.gsub(/\s+/, '') + "."
      caseEnum = line.sub(sub, "").delete!("\n").split('" = "').first
      oldNameEnum = caseEnum
      if forbiddenNames.include? caseEnum
        caseEnum = "\`" + caseEnum + "\`"
      end

      if !caseEnum.nil?
        normalLine = "\t\t\t" +
          "static let " +
          caseEnum +
          " = " +
          "\"" +
          "\\" +
          "(key)." +
          oldNameEnum +
          "\"" +
          ".localized"
        localization_file.puts normalLine
      end
    end
  end
end
# puts(localization_file.basename)
localization_file.puts("\t}")
localization_file.puts("}")
localization_file.close
