MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171204142458.GA3325@pjb1027-Latitude-E5410>
References: <20171204142458.GA3325@pjb1027-Latitude-E5410>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 5 Dec 2017 11:56:07 -0800
Message-ID: <CAGXu5jK4_A7ZxxJ_9M5auAd3=OZNMK+srcbeNRuhgwdW16qUbQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening][PATCH v3 0/3] arm: Makes ptdump resuable and
 add WX page checking
To: Jinbum Park <jinb.park7@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Afzal Mohammed <afzal.mohd.ma@gmail.com>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@redhat.com>, Russell King <linux@armlinux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Vladimir Murzin <vladimir.murzin@arm.com>, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 4, 2017 at 6:24 AM, Jinbum Park <jinb.park7@gmail.com> wrote:
> Hi,
>
> Page table dumping code for arm64-x86 is reusable,
> and they have function for WX page checking.
> But arm doesn't have that.
>
> This path series are to makes ptdump reusable,
> and add WX page checking for arm.
> This is heavily based on arm64 version.

Thanks for working on this! I sent along a few nits.

-Kees

>
> v2 :
> Fix a sender name of mail header, there was an mistake.
> (from "jinb.park" to Jinbum Park)
> Contents of patch-set are perfectly same.
>
> v3 :
> Take advantage of the existing pg_level and bits arrays
> to check ro, nx prot.
>
> jinb.park (3):
>   arm: mm: dump: make page table dumping reusable
>   arm: mm: dump: make the page table dumping seq_file optional
>   arm: mm: dump: add checking for writable and executable pages
>
>  arch/arm/Kconfig.debug        |  33 +++++++++-
>  arch/arm/include/asm/ptdump.h |  56 ++++++++++++++++
>  arch/arm/mm/Makefile          |   3 +-
>  arch/arm/mm/dump.c            | 144 +++++++++++++++++++++++++++++-------------
>  arch/arm/mm/init.c            |   2 +
>  arch/arm/mm/ptdump_debugfs.c  |  34 ++++++++++
>  6 files changed, 226 insertions(+), 46 deletions(-)
>  create mode 100644 arch/arm/include/asm/ptdump.h
>  create mode 100644 arch/arm/mm/ptdump_debugfs.c
>
> --
> 1.9.1
>



-- 
Kees Cook
Pixel Security
