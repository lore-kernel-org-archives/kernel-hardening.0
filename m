MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170418144057.1e9c2103@lxorguk.ukuu.org.uk>
References: <20170417060706.28674-1-matt@nmatt.com> <20170417060706.28674-2-matt@nmatt.com>
 <20170417065055.GA21022@kroah.com> <20170418144057.1e9c2103@lxorguk.ukuu.org.uk>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 18 Apr 2017 08:49:10 -0700
Message-ID: <CAGXu5j+mP784rGqx1CWOOXM=AhAN7EegRZxO_=OG0y6k0hQs+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH 1/4] added SECURITY_TIOCSTI_RESTRICT
 kernel config
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, Matt Brown <matt@nmatt.com>, James Morris <jmorris@namei.org>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module <linux-security-module@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 18, 2017 at 6:40 AM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
>> Since tty sessions are usually separated by different users, how would
>> they have the same one and yet need something like this?
>>
>> Also, why not put this in the tty config section?
>
> The normal attack use case people argue about is a rogue process on the
> users machine sitting there waiting until the user has logged in to a
> remote machine and is idle and then doing stuff.

It's still a threat, though, and adding this with default n to allow
the more paranoid builders a chance to mitigate it seems reasonable to
me.

> Attackers of course don't bother doing that because it's easier to get
> the user to run a different ssh client instead.

Attackers will always take the easiest route, so we have to keep
killing the low hanging fruit.

-Kees

-- 
Kees Cook
Pixel Security
