Message-ID: <1494450134.28559.2.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 10 May 2017 17:02:14 -0400
In-Reply-To: <20170510212920.7f6bc5e6@alans-desktop>
References: <20170505232018.28846-1-matt@nmatt.com>
	 <20170510212920.7f6bc5e6@alans-desktop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make
 TIOCSTI ioctl require CAP_SYS_ADMIN
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Matt Brown <matt@nmatt.com>
Cc: serge@hallyn.com, gregkh@linuxfoundation.org, jslaby@suse.com, akpm@linux-foundation.org, jannh@google.com, keescook@chromium.org, jmorris@namei.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-05-10 at 21:29 +0100, Alan Cox wrote:
> 
> In addition your change to allow it to be used by root in the guest
> completely invalidates any protection you have because I can push
> 
> "rm -rf /\n"
> 
> as root in my namespace and exit
> 
> The tty buffers are not flushed across the context change so the shell
> you return to gets the input and oh dear....
> 
> Alan

I might be missing something, but it looks like the patch tracks where
the tty was created and only allows this with CAP_SYS_ADMIN in the ns
where the tty came from.
