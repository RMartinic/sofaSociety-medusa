import { Suspense } from "react"
import { listRegions } from "@lib/data/regions"
import { StoreRegion } from "@medusajs/types"
import LocalizedClientLink from "@modules/common/components/localized-client-link"
import CartButton from "@modules/layout/components/cart-button"
import SideMenu from "@modules/layout/components/side-menu"
import { DropdownMenu } from "@medusajs/ui"
import { FaSearch } from "react-icons/fa"

export default async function Nav() {
  const regions = await listRegions().then((regions: StoreRegion[]) => regions)

  return (
    <div className="sticky top-0 inset-x-0 z-50">
      <header className="relative h-16 mx-auto bg-transparent">
        <nav className="content-container txt-xsmall-plus text-ui-fg-subtle flex items-center justify-between w-full h-full text-small-regular">
          <div className="flex items-center gap-x-6 h-full">
            <SideMenu regions={regions} />
            <LocalizedClientLink
              className="hover:text-ui-fg-base"
              href="/about"
            >
              About
            </LocalizedClientLink>
            <LocalizedClientLink
              className="hover:text-ui-fg-base"
              href="/inspiration"
            >
              Inspiration
            </LocalizedClientLink>
            <LocalizedClientLink className="hover:text-ui-fg-base" href="/shop">
              Shop
            </LocalizedClientLink>
          </div>

          <div className="flex items-center h-full">
            <LocalizedClientLink
              href="/"
              className="txt-compact-xlarge-plus hover:text-ui-fg-base uppercase"
            >
              SofaSocietyCo.
            </LocalizedClientLink>
          </div>

          <div className="flex items-center gap-x-6 h-full">
            <DropdownMenu>
              <DropdownMenu.Trigger>ENG</DropdownMenu.Trigger>
              <DropdownMenu.Content>
                <DropdownMenu.Item>HR</DropdownMenu.Item>
                <DropdownMenu.Item>ENG</DropdownMenu.Item>
              </DropdownMenu.Content>
            </DropdownMenu>

            <button className="hover:text-ui-fg-base">
              <FaSearch size={20} />
            </button>

            <Suspense
              fallback={
                <LocalizedClientLink
                  className="hover:text-ui-fg-base flex gap-2"
                  href="/cart"
                >
                  Cart (0)
                </LocalizedClientLink>
              }
            >
              <CartButton />
            </Suspense>
          </div>
        </nav>
      </header>
    </div>
  )
}
