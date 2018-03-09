Date: Fri, 9 Mar 2018 17:28:50 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: [PATCH 4/4] video: Remove stack VLA usage
Message-ID: <20180309062850.GD16734@eros>
References: <1520574625-4225-1-git-send-email-me@tobin.cc>
 <1520575267.11634.25.camel@perches.com>
 <20180309061152.r3yumh6agasyhtvo@cisco>
 <d99bbd46-8fed-b86f-c043-272ebc96e023@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d99bbd46-8fed-b86f-c043-272ebc96e023@embeddedor.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Tycho Andersen <tycho@tycho.ws>, Joe Perches <joe@perches.com>, Florian Tobias Schandinat <FlorianSchandinat@gmx.de>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 09, 2018 at 12:16:21AM -0600, Gustavo A. R. Silva wrote:
> 
> I sent a patch for this six hours ago:
> 
> https://patchwork.kernel.org/patch/10268591/
> 
> --
> Gustavo

lol, I knew there would be a race on to fix these :)  And you got it
right, bonus points. Let's drop this one then.


thanks,
Tobin.
