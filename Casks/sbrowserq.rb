cask "sbrowserq" do
  version_without_patch = "3.7"

  version "#{version_without_patch}.4"
  sha256 "8952a2095efc2f658c0dc03cee7a5c77a1ab07bdd4186a089826665b13a4227e"

  url "https://www.sbrowser-q.com/SBrowserQ_V#{version_without_patch}_mac.dmg"
  name "sbrowserq"
  desc "Shogi game playing and game record management"
  homepage "https://www.sbrowser-q.com/"

  livecheck do
    url :homepage
    strategy :page_match
    regex(/V(\d\.\d\.\d)/)
  end

  app "SBrowserQ.app"
end
