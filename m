Reply-To: kernel-hardening@lists.openwall.com
References: <20160908223558.GA11742@www.outflux.net>
 <43f1953c-d8a3-647f-20eb-bec4898e1b8e@suse.cz>
 <20160914150416.2d938c60@lxorguk.ukuu.org.uk>
 <CAGXu5jJWE-z_DLwP=cZdSMkJLYhQ+B2=AEEdCuFDucxsSn9b-w@mail.gmail.com>
From: Jiri Slaby <jslaby@suse.cz>
Message-ID: <cbf298aa-6c4c-9a72-fbe0-f4b862bd838f@suse.cz>
Date: Wed, 21 Sep 2016 11:40:54 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJWE-z_DLwP=cZdSMkJLYhQ+B2=AEEdCuFDucxsSn9b-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] pty: make ptmx file ops read-only after init
To: Kees Cook <keescook@chromium.org>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 09/14/2016, 06:17 PM, Kees Cook wrote:
> Correct, this is a continuing effort to reduce the internal attack
> surface of the kernel, where one of the most common exploitation
> methods is overwriting function pointers.
> 
> Some examples of attacks and mitigations are here:
> http://kernsec.org/wiki/index.php/Exploit_Methods/Function_pointer_overwrite
> 
> While this patch isn't a huge change, it's still a viable candidate. I
> send these as I notice them, and hope that other folks will start to
> see these opportunities and send more patches too. :)

I didn't object to the patch. I could imagine the use case. But putting
the idea to the commit message would have made it clear.

thanks,
-- 
js
suse labs
