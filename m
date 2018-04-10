Date: Tue, 10 Apr 2018 23:06:34 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH] drm/i2c: tda998x: Remove VLA usage
Message-ID: <20180410220634.GZ16141@n2100.armlinux.org.uk>
References: <20180409210703.3787-1-labbott@redhat.com>
 <20180409222141.GR16141@n2100.armlinux.org.uk>
 <855433a0-72f5-df29-3a17-5c2016e988e1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <855433a0-72f5-df29-3a17-5c2016e988e1@redhat.com>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Laura Abbott <labbott@redhat.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 10, 2018 at 02:52:35PM -0700, Laura Abbott wrote:
> On 04/09/2018 03:21 PM, Russell King - ARM Linux wrote:
> >On Mon, Apr 09, 2018 at 02:07:03PM -0700, Laura Abbott wrote:
> >>There's an ongoing effort to remove VLAs[1] from the kernel to eventually
> >>turn on -Wvla. The vla in reg_write_range is based on the length of data
> >>passed. The one use of a non-constant size for this range is bounded by
> >>the size buffer passed to hdmi_infoframe_pack which is a fixed size.
> >>Switch to this upper bound.
> >
> >Does this _really_ make it safer?  What if the code is modified to write
> >more than 32 bytes in the future?
> >
> >Sorry, I don't think this is safer at all.
> >
> 
> Yeah I wasn't 100% sure about this one. Elsewhere, we've added bounds
> checks against the new static size buffer so we could do that here
> to ensure we don't overrun the stack if we do need to write more
> than 32 bytes in the future. Another option is to switch to
> a kmalloc buffer. Are either of those options acceptable to you or
> do you have a better idea of how to get rid of the VLA?

Limiting the size would be better (with an error message/WARN_ON) -
at least that results in a diagnostic message to alert the developer
rather than silently stomping over the stack.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
