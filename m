MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170606225739.GA14682@openwall.com>
References: <20170606215534.GA13126@openwall.com> <20170606221617.GA14451@openwall.com>
 <20170606225739.GA14682@openwall.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 6 Jun 2017 21:00:02 -0700
Message-ID: <CAGXu5jK97z6Kb5VJMKhMcP61P8yeZaVTinVPS2aL5QFm9GbKqg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] symlink/hardlink/FIFO restrictions
To: Solar Designer <solar@openwall.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 6, 2017 at 3:57 PM, Solar Designer <solar@openwall.com> wrote:
> On Wed, Jun 07, 2017 at 12:16:17AM +0200, Solar Designer wrote:
>> So we're only protecting against bad symlinks for the last pathname
>> component - not for upper directories in the path.  Indeed, for typical
>> vulnerable programs it's the last pathname component that would be
>> attacked, but I am not sure if it's always the case nor whether we
>> needed this limitation in this security feature for some desirable uses.
>>
>> Does this mean symlink attacks against not-yet-created directories like
>> /tmp/.X11-unix (so perhaps during the system's bootup, maybe when it
>> already started sshd but not yet X) are still possible even with the
>> feature enabled?
>
> Confirmed this by testing (with a dummy user-owned directory in /tmp).
>
> I think this is actually fine, because we were not protecting against a
> variation of those attacks anyway: where the attacker could have created
> a non-+t directory of their own in place of /tmp/.X11-unix or the like.
> Then symlinks placed in that directory wouldn't be protected anyway.

IIRC, the "trailing" part was requested by Al Viro in his various
reviews of my port of the defense, and I came to the same conclusion:
we can't really protected the non-+t directory case without some very
different semantics.

I couldn't come up with a situation where the intended defense didn't
work as expected, but maybe I lacked imagination.

-Kees

-- 
Kees Cook
Pixel Security
