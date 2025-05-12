module SquareMobilePaymentsSDK
  VERSION = '2.2.3'
  COMMIT_SHA = '56ca6e860134'
  CLOUDFRONT_DOMAIN = 'd3eygymyzkbhx3.cloudfront.net'
  LICENSE_TYPE = 'Square Developer License'
  LICENSE_TEXT = <<-LICENSE
Copyright (c) 2020-present, Square, Inc. All rights reserved.

Your use of this software is subject to the Square Developer Terms of
Service (https://squareup.com/legal/developers). This copyright notice shall
be included in all copies or substantial portions of the software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
    LICENSE
  LICENSE = { type: LICENSE_TYPE, text: LICENSE_TEXT }

  # Since this is a binary pod, redirect the Cocoapods.org entry to the github repo.
  HOMEPAGE_URL = 'https://github.com/square/mobile-payments-sdk-ios'
  AUTHORS = 'Square'
  IOS_DEPLOYMENT_TARGET = '16.0'
end
