Date: Mon, 20 Feb 2017 09:14:17 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
Message-ID: <20170220091417.14b21484@xeon-e3>
In-Reply-To: <20170218055844.1457-2-ewk@edkovsky.org>
References: <20170218055844.1457-1-ewk@edkovsky.org>
	<20170218055844.1457-2-ewk@edkovsky.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 1/3] module: verify address is read-only
To: Eddie Kovsky <ewk@edkovsky.org>
Cc: jeyu@redhat.com, rusty@rustcorp.com.au, keescook@chromium.org, KY
 Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 17 Feb 2017 21:58:42 -0800
"Eddie Kovsky" <ewk@edkovsky.org> wrote:

> Implement a mechanism to check if a module's address is in
> the rodata or ro_after_init sections. It mimics the exsiting functions
> that test if an address is inside a module's text section.
> 
> Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>

I don't see the point of this for many of the hyper-v functions.
They are only called from a small number of places, and this can be validated
by code inspection. Adding this seems just seems to be code bloat to me.
