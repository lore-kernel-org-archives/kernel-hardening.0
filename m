Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 18 Jan 2017 23:45:28 +0000
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20170118234527.GW27312@n2100.armlinux.org.uk>
References: <20170118135310.GA4733@pjb1027-Latitude-E5410>
 <e5433e24-7a3d-25a4-26a3-9d02644cc3f4@redhat.com>
 <20170118223629.GQ27312@n2100.armlinux.org.uk>
 <46bae2bb-4b4f-158b-6a8d-3737e181ad74@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46bae2bb-4b4f-158b-6a8d-3737e181ad74@redhat.com>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [kernel-hardening] Re: [PATCH] ARM: mm: add testcases for RODATA
To: Laura Abbott <labbott@redhat.com>
Cc: kernel-hardening@lists.openwall.com, mark.rutland@arm.com, f.fainelli@gmail.com, keescook@chromium.org, pawel.moll@arm.com, ard.biesheuvel@linaro.org, will.deacon@arm.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Jinbum Park <jinb.park7@gmail.com>, vladimir.murzin@arm.com, linux-arm-kernel@lists.infradead.org, andy.gross@linaro.org, arjan@linux.intel.com, mingo@kernel.org, paul.gortmaker@windriver.com, jonathan.austin@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 18, 2017 at 03:38:52PM -0800, Laura Abbott wrote:
> On 01/18/2017 02:36 PM, Russell King - ARM Linux wrote:
> > I don't see why this needs to be in cacheflush.h - it doesn't seem to
> > have anything to do with cache flushing, and placing it in here means
> > that if you change the state of CONFIG_DEBUG_RODATA_TEST, most likely
> > the entire kernel gets rebuilt.  Please put it in a separate header
> > file.
> 
> cacheflush.h seems to be where all the set_memory_* functions have
> ended up. I was just looking at cleaning that up unless someone
> beats me to it.

+1

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
