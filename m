Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160914150416.2d938c60@lxorguk.ukuu.org.uk>
References: <20160908223558.GA11742@www.outflux.net> <43f1953c-d8a3-647f-20eb-bec4898e1b8e@suse.cz>
 <20160914150416.2d938c60@lxorguk.ukuu.org.uk>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 14 Sep 2016 09:17:44 -0700
Message-ID: <CAGXu5jJWE-z_DLwP=cZdSMkJLYhQ+B2=AEEdCuFDucxsSn9b-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] pty: make ptmx file ops read-only after init
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jslaby@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Sep 14, 2016 at 7:04 AM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> On Wed, 14 Sep 2016 09:59:42 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
>
>> On 09/09/2016, 12:35 AM, Kees Cook wrote:
>> > The ptmx_fops structure is only changed during init, so mark it as such.
>>
>> Right, but I am missing what is the benefit? You would have to elaborate
>> here...
>
> The pages end up marked read only even to the kernel (and in future could
> even be marked read only forever when in kvm if we get suitable virtual
> machine extensions). That makes it much harder to patch those vectors
> when making security attacks.

Correct, this is a continuing effort to reduce the internal attack
surface of the kernel, where one of the most common exploitation
methods is overwriting function pointers.

Some examples of attacks and mitigations are here:
http://kernsec.org/wiki/index.php/Exploit_Methods/Function_pointer_overwrite

While this patch isn't a huge change, it's still a viable candidate. I
send these as I notice them, and hope that other folks will start to
see these opportunities and send more patches too. :)

-Kees

-- 
Kees Cook
Nexus Security
