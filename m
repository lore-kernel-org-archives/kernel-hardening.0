Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 16 May 2016 19:37:10 -0700
From: Greg KH <greg@kroah.com>
Message-ID: <20160517023710.GA14736@kroah.com>
References: <20160517022728.GA2821@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160517022728.GA2821@www.outflux.net>
Subject: Re: [kernel-hardening] [PATCH] doc: self-protection: provide initial
 details
To: kernel-hardening@lists.openwall.com
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 16, 2016 at 07:27:28PM -0700, Kees Cook wrote:
> This document attempts to codify the intent around kernel self-protection
> along with discussion of both existing and desired technologies, with
> attention given to the rationale behind them, and the expectations of
> their usage.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/security/self-protection.txt | 261 +++++++++++++++++++++++++++++
>  1 file changed, 261 insertions(+)
>  create mode 100644 Documentation/security/self-protection.txt

Nice job:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
