Date: Wed, 23 Jan 2019 12:58:29 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/3] treewide: Lift switch variables out of switches
Message-ID: <20190123115829.GA31385@kroah.com>
References: <20190123110349.35882-1-keescook@chromium.org>
 <20190123110349.35882-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190123110349.35882-2-keescook@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Alexander Popov <alex.popov@linux.com>, xen-devel@lists.xenproject.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, dev@openvswitch.org, linux-kbuild@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 23, 2019 at 03:03:47AM -0800, Kees Cook wrote:
> Variables declared in a switch statement before any case statements
> cannot be initialized, so move all instances out of the switches.
> After this, future always-initialized stack variables will work
> and not throw warnings like this:
> 
> fs/fcntl.c: In function ‘send_sigio_to_task’:
> fs/fcntl.c:738:13: warning: statement will never be executed [-Wswitch-unreachable]
>    siginfo_t si;
>              ^~

That's a pain, so this means we can't have any new variables in { }
scope except for at the top of a function?

That's going to be a hard thing to keep from happening over time, as
this is valid C :(

greg k-h
