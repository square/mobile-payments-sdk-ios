Pod::Spec.new do |s|
  s.name = 'SquareMobilePaymentsSDK'
  s.version = '2.2.4'
  s.license = {:type=>"Square Developer License", :text=>"Copyright (c) 2020-present, Square, Inc. All rights reserved.\n\nYour use of this software is subject to the Square Developer Terms of\nService (https://squareup.com/legal/developers). This copyright notice shall\nbe included in all copies or substantial portions of the software.\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN\nTHE SOFTWARE.\n"}
  s.homepage = 'https://github.com/square/mobile-payments-sdk-ios'
  s.authors = 'Square'
  s.summary = 'Enables developers to build secure in-person payment solutions'

  s.ios.deployment_target = '16.0'

  s.source ={ :http => "https://d3eygymyzkbhx3.cloudfront.net/mpsdk/2.2.4/SquareMobilePaymentsSDK_85274b307ec5.zip" }
  s.vendored_frameworks = 'SquareMobilePaymentsSDK.xcframework'

end
