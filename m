Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Sep 2016 15:04:16 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20160914150416.2d938c60@lxorguk.ukuu.org.uk>
In-Reply-To: <43f1953c-d8a3-647f-20eb-bec4898e1b8e@suse.cz>
References: <20160908223558.GA11742@www.outflux.net>
	<43f1953c-d8a3-647f-20eb-bec4898e1b8e@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] pty: make ptmx file ops read-only after init
To: Jiri Slaby <jslaby@suse.cz>
Cc: Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 14 Sep 2016 09:59:42 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> On 09/09/2016, 12:35 AM, Kees Cook wrote:
> > The ptmx_fops structure is only changed during init, so mark it as such.  
> 
> Right, but I am missing what is the benefit? You would have to elaborate
> here...

The pages end up marked read only even to the kernel (and in future could
even be marked read only forever when in kvm if we get suitable virtual
machine extensions). That makes it much harder to patch those vectors
when making security attacks.
