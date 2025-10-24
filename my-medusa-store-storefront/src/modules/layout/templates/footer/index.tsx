import { Text, clx } from "@medusajs/ui"
import LocalizedClientLink from "@modules/common/components/localized-client-link"

export default function Footer() {
  return (
    <footer className="border-t border-ui-border-base w-full py-16">
      <div className="content-container flex flex-col md:flex-row justify-between gap-y-10 md:gap-y-0">
        <div className="flex flex-col gap-y-1">
          <LocalizedClientLink
            href="/"
            className="txt-compact-xlarge-plus text-ui-fg-subtle hover:text-ui-fg-base uppercase"
          >
            Sofa
            <br />
            Society
            <br />
            Co.
          </LocalizedClientLink>
          <span>@2024, Sofa Society</span>
        </div>

        <div className="flex flex-col sm:flex-row gap-x-10 md:gap-x-16">
          <div className="flex flex-col gap-y-2">
            <span className="txt-small-plus txt-ui-fg-base">Help</span>
            <ul className="flex flex-col gap-y-1 txt-small text-ui-fg-subtle">
              <li>
                <LocalizedClientLink
                  href="/faq"
                  className="hover:text-ui-fg-base"
                >
                  FAQ
                </LocalizedClientLink>
              </li>
              <li>
                <LocalizedClientLink
                  href="/help"
                  className="hover:text-ui-fg-base"
                >
                  Help
                </LocalizedClientLink>
              </li>
              <li>
                <LocalizedClientLink
                  href="/delivery"
                  className="hover:text-ui-fg-base"
                >
                  Delivery
                </LocalizedClientLink>
              </li>
              <li>
                <LocalizedClientLink
                  href="/returns"
                  className="hover:text-ui-fg-base"
                >
                  Returns
                </LocalizedClientLink>
              </li>
            </ul>
          </div>

          <div className="flex flex-col gap-y-2">
            <span className="txt-small-plus txt-ui-fg-base">Social</span>
            <ul className="flex flex-col gap-y-1 txt-small text-ui-fg-subtle">
              <li>
                <a
                  href="https://instagram.com"
                  target="_blank"
                  rel="noreferrer"
                  className="hover:text-ui-fg-base"
                >
                  Instagram
                </a>
              </li>
              <li>
                <a
                  href="https://tiktok.com"
                  target="_blank"
                  rel="noreferrer"
                  className="hover:text-ui-fg-base"
                >
                  TikTok
                </a>
              </li>
              <li>
                <a
                  href="https://pinterest.com"
                  target="_blank"
                  rel="noreferrer"
                  className="hover:text-ui-fg-base"
                >
                  Pinterest
                </a>
              </li>
              <li>
                <a
                  href="https://facebook.com"
                  target="_blank"
                  rel="noreferrer"
                  className="hover:text-ui-fg-base"
                >
                  Facebook
                </a>
              </li>
            </ul>
          </div>

          <div className="flex flex-col gap-y-2">
            <span className="txt-small-plus txt-ui-fg-base">Legal</span>
            <ul className="flex flex-col gap-y-1 txt-small text-ui-fg-subtle">
              <li>
                <LocalizedClientLink
                  href="/privacy"
                  className="hover:text-ui-fg-base"
                >
                  Privacy Policy
                </LocalizedClientLink>
              </li>
              <li>
                <LocalizedClientLink
                  href="/cookies"
                  className="hover:text-ui-fg-base"
                >
                  Cookie Policy
                </LocalizedClientLink>
              </li>
              <li>
                <LocalizedClientLink
                  href="/terms"
                  className="hover:text-ui-fg-base"
                >
                  Terms of Use
                </LocalizedClientLink>
              </li>
            </ul>
          </div>
        </div>

        <div className="flex flex-col gap-y-2 max-w-xs">
          <span className="txt-small-plus txt-ui-fg-base">
            Join our newsletter
          </span>
          <form className="flex flex-col gap-y-2">
            <input
              type="email"
              placeholder="Your email"
              className="border border-ui-border-base px-3 py-2 rounded text-ui-fg-base focus:outline-none focus:ring-2 focus:ring-ui-primary"
            />
            <button
              type="submit"
              className="bg-ui-primary text-white px-4 py-2 rounded hover:bg-ui-primary-dark"
            >
              Subscribe
            </button>
          </form>
          <Text className="txt-small text-ui-fg-subtle">
            Subscribe for coupons and updates. We respect your privacy.
          </Text>
        </div>
      </div>

      <div className="mt-10 border-t border-ui-border-base pt-4 text-ui-fg-muted text-small">
        © {new Date().getFullYear()} Sofa Society Co. All rights reserved.
      </div>
    </footer>
  )
}
