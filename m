MIME-Version: 1.0
In-Reply-To: <20171207105319.GA10075@pjb1027-Latitude-E5410>
References: <20171207105319.GA10075@pjb1027-Latitude-E5410>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Thu, 7 Dec 2017 12:30:47 +0100
Message-ID: <CAOFm3uFzFpDrc4KhH0qOLkXLioz=Fcz56hN-+POwuUHTAerv5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening][PATCH v5 1/3] arm: mm: dump: make page table
 dumping reusable
To: Jinbum Park <jinb.park7@gmail.com>
Cc: "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, afzal.mohd.ma@gmail.com, Mark Rutland <mark.rutland@arm.com>, labbott@redhat.com, Russell King <linux@armlinux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, keescook@chromium.org, vladimir.murzin@arm.com, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

Dear Jinbum,

On Thu, Dec 7, 2017 at 11:53 AM, Jinbum Park <jinb.park7@gmail.com> wrote:
> This patch refactors the arm page table dumping code,
> so multiple tables may be registered with the framework.
>
> This patch refers below commits of arm64.
> (4674fdb9f149 ("arm64: mm: dump: make page table dumping reusable"))
> (4ddb9bf83349 ("arm64: dump: Make ptdump debugfs a separate option"))
>
> Tested-by: Laura Abbott <labbott@redhat.com>
> Reviewed-by: Laura Abbott <labbott@redhat.com>
> Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
[]
> diff --git a/arch/arm/include/asm/ptdump.h b/arch/arm/include/asm/ptdump.h
> new file mode 100644
> index 0000000..3a6c0b7
> --- /dev/null
> +++ b/arch/arm/include/asm/ptdump.h
> @@ -0,0 +1,48 @@
> +/*
> + * Copyright (C) 2014 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */

Sorry if I am nitpicking, but have you considered replacing this
beautiful piece of fine legalese with the new SPDX ids?
e.g. this:
// SPDX-License-Identifier: GPL-2.0
// Copyright (C) 2014 ARM Ltd.

Or if this does not work and your includes break something if they are
used in assembly, then this can work out too

> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2014 ARM Ltd. */

See Thomas doc patches, and Greg and Linus comments on these topics.

This is much leaner, is it?
Less legalese comment also means more code and a better, smaller
boilerplate lines/total lines ratio!
Thank you for your kind consideration.

-- 
Cordially
Philippe Ombredanne
