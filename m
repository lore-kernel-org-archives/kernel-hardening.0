Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 16 Nov 2016 17:14:46 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161116161446.GA22095@kroah.com>
References: <CAAseMr6Fae=4otZZX9HmO1YgehjsVmd+44G5RN7Wu8iF2+fruA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAseMr6Fae=4otZZX9HmO1YgehjsVmd+44G5RN7Wu8iF2+fruA@mail.gmail.com>
Subject: Re: [kernel-hardening] patches for __write_rarely section
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 16, 2016 at 10:39:38PM +0800, Gengjia Chen wrote:
> From: chengengjia <chengjia4574@gmail.com>
> Date: Wed, 16 Nov 2016 21:46:49 +0800
> Subject: [PATCH] arch: introduce write-rarely memory section
> 
> This introduces __write_rarely section as a way
> to mark those memory that read only in most case,
> but also need to be written to sometimes.
> 
> Signed-off-by: chengengjia <chengjia4574@gmail.com>

Minor nit, please use your full/real name for From: and signed-off-by:
lines.

thanks,

greg k-h
