MIME-Version: 1.0
In-Reply-To: <20170425144746.0d8721a3@lxorguk.ukuu.org.uk>
References: <20170425041512.13189-1-matt@nmatt.com> <20170425144746.0d8721a3@lxorguk.ukuu.org.uk>
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Apr 2017 15:56:32 +0200
Message-ID: <CAG48ez0uYkAg65iBZ8cKLxzFyEK=Axt=NP7jnmQkFp4rN=0GzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 0/2] security: tty: make TIOCSTI ioctl require CAP_SYS_ADMIN
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Matt Brown <matt@nmatt.com>, serge@hallyn.com, jmorris@namei.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jslaby@suse.com, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 25, 2017 at 3:47 PM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
>> There could be a few user programs that would be effected by this
>> change.
>> See: <https://codesearch.debian.net/search?q=ioctl%5C%28.*TIOCSTI>
>> notable programs are: agetty, csh, xemacs and tcsh
>>
>> However, I still believe that this change is worth it given that the
>> Kconfig defaults to n. This will be a feature that is turned on for the
>> same reason that people activate it when using grsecurity. Users of this
>> opt-in feature will realize that they are choosing security over some OS
>> features
>
> Only in this case they are not.
>
> If I am at the point I have the ability to send you TIOCSTI you already
> lost because I can just open /dev/tty to get access to my controlling tty
> and use write().

In terms of PTYs, this patch does not try to prevent writes to a slave
device (which afaik is what /dev/tty will give you). It tries to prevent the
equivalent of writes to the master device. As far as I know, there is no
way to go from a slave to the corresponding master without having
access to the master in some other way already.
