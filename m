Sender: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Wed, 23 May 2018 10:46:14 +0200
From: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCHv2] drm/i2c: tda998x: Remove VLA usage
Message-ID: <20180523084614.GL3438@phenom.ffwll.local>
References: <20180411010330.17866-1-labbott@redhat.com>
 <CAGXu5jK-qTdkDi2bC7DZg-bR-tFjSGOZsNB9_b-F++qMgdcF+Q@mail.gmail.com>
 <20180519100707.GI17671@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180519100707.GI17671@n2100.armlinux.org.uk>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Daniel Vetter <daniel.vetter@ffwll.ch>, Laura Abbott <labbott@redhat.com>, David Airlie <airlied@linux.ie>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, May 19, 2018 at 11:07:08AM +0100, Russell King - ARM Linux wrote:
> On Fri, May 18, 2018 at 11:01:55AM -0700, Kees Cook wrote:
> > On Tue, Apr 10, 2018 at 6:03 PM, Laura Abbott <labbott@redhat.com> wrote:
> > > There's an ongoing effort to remove VLAs[1] from the kernel to eventually
> > > turn on -Wvla. The vla in reg_write_range is based on the length of data
> > > passed. The one use of a non-constant size for this range is bounded by
> > > the size buffer passed to hdmi_infoframe_pack which is a fixed size.
> > > Switch to this upper bound.
> > >
> > > [1] https://lkml.org/lkml/2018/3/7/621
> > >
> > > Signed-off-by: Laura Abbott <labbott@redhat.com>
> > 
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > 
> > Same question for this patch: who's best to take this?
> 
> I had decided that I'm not taking any tda998x stuff until we get the
> CEC support merged upstream, as that has been hanging around for ages.
> Progress has been slow on that, but it finally got to the point where
> everyone was happy with it, and I sent a pull request to David Airlie
> on April 24th for it.
> 
> Unfortunately, that pull request has not been actioned to date.  I've
> sent a chaser, and last night, I checked with David Airlie on IRC.
> It seems David is not aware of my pull request.  David says he'll look
> into this on Monday.
> 
> Until David does take it, I can't add anything further to my git tree
> for tda998x development, as that would change what was sent to David
> back in April.
> 
> The alternative would be for drm-misc to take it - I don't think it
> will conflict with anything I've already asked David to take, so that
> should be a safe route for _this_ patch.

Sounds reasonable, applied to drm-misc-next for 4.19 just to make sure it
won't get lost.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
