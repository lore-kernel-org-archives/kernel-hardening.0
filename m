References: <20170505232018.28846-1-matt@nmatt.com>
 <20170510212920.7f6bc5e6@alans-desktop>
From: Matt Brown <matt@nmatt.com>
Message-ID: <e73698a7-7b6a-a916-3270-82dcfe0a558b@nmatt.com>
Date: Sat, 13 May 2017 15:52:58 -0400
MIME-Version: 1.0
In-Reply-To: <20170510212920.7f6bc5e6@alans-desktop>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v6 0/2] security: tty: make TIOCSTI ioctl require
 CAP_SYS_ADMIN
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: serge@hallyn.com, gregkh@linuxfoundation.org, jslaby@suse.com, akpm@linux-foundation.org, jannh@google.com, keescook@chromium.org, jmorris@namei.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 05/10/2017 04:29 PM, Alan Cox wrote:
> On Fri,  5 May 2017 19:20:16 -0400
> Matt Brown <matt@nmatt.com> wrote:
>
>> This patchset introduces the tiocsti_restrict sysctl, whose default is
>> controlled via CONFIG_SECURITY_TIOCSTI_RESTRICT. When activated, this
>> control restricts all TIOCSTI ioctl calls from non CAP_SYS_ADMIN users.
>>
>> This patch was inspired from GRKERNSEC_HARDEN_TTY.
>>
>> This patch would have prevented
>> https://bugzilla.redhat.com/show_bug.cgi?id=1411256 under the following
>> conditions:
>> * non-privileged container
>> * container run inside new user namespace
>>
>> Possible effects on userland:
>>
>> There could be a few user programs that would be effected by this
>> change.
>> See: <https://codesearch.debian.net/search?q=ioctl%5C%28.*TIOCSTI>
>> notable programs are: agetty, csh, xemacs and tcsh
>>
>> However, I still believe that this change is worth it given that the
>> Kconfig defaults to n.
>
> And it still doesn't deal with the fact that there are hundreds of other
> ways to annoy the owner of a tty if it's passed to a lower privilege
> child from framebuffer reprogramming through keyboard remaps.
>
> The proper way to handle those cases is to create a pty/tty pair and use
> that. Your patch is pure snake oil and if anything implies safety that
> doesn't exist.
>

I'm not implying that my patch is supposed to provide safety for
"hundreds of other" issues. I'm looking to provide a way to lock down a
single TTY ioctl that has caused real security issues to arise. For
this reason, it's completely incorrect to say that this feature is
snake oil. My patch does exactly what it claims to do. No more no less.

> In addition your change to allow it to be used by root in the guest
> completely invalidates any protection you have because I can push
>
> "rm -rf /\n"
>
> as root in my namespace and exit
>
> The tty buffers are not flushed across the context change so the shell
> you return to gets the input and oh dear....

This is precisely what my patch prevents! With my protection enabled, a
container will only be able to use the TIOCSTI ioctl on a tty if that
container has CAP_SYS_ADMIN in the user namespace in which the tty was
created.

>
> Alan
>
