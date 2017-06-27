MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170627073132.GC28078@dhcp22.suse.cz>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
 <1497915397-93805-23-git-send-email-keescook@chromium.org>
 <06bde73d-ca3c-8f91-0142-ddf3af99875e@redhat.com> <CAGXu5jKBB8TF7e74QkuxOu0iy6TZe3Q_0Fs21tbyq23Js3v3Mw@mail.gmail.com>
 <20170627073132.GC28078@dhcp22.suse.cz>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 27 Jun 2017 15:07:17 -0700
Message-ID: <CAGXu5jK5L8ZhMAHEMBDWhnDMDS-Wt-aNMUbOMrMHT25qWqNoRA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 22/23] usercopy: split user-controlled slabs to separate caches
To: Michal Hocko <mhocko@kernel.org>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, David Windsor <dave@nullcore.net>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 27, 2017 at 12:31 AM, Michal Hocko <mhocko@kernel.org> wrote:
> But I am not really sure I understand consequences of this patch. So how
> do those attacks look like. Do you have an example of a CVE which would
> be prevented by this measure?

It's a regular practice, especially for heap grooming. You can see an
example here:
http://cyseclabs.com/blog/cve-2016-6187-heap-off-by-one-exploit
which even recognizes this as a common method, saying "the standard
msgget() technique". Having the separate caches doesn't strictly
_stop_ some attacks, but it changes the nature of what the attacker
has to do. Instead of having a universal way to groom the heap, they
must be forced into other paths. Generally speaking this can reduce
what's possible making the attack either impossible, more expensive to
develop, or less reliable.

>> This would mean building out *_user() versions for all the various
>> *alloc() functions, though. That gets kind of long/ugly.
>
> Only prepare those which are really needed. It seems only handful of
> them in your patch.

Okay, if that's the desired approach, we can do that.

> OK, I was about to ask about vmalloc fallbacks. So this is not
> implemented in your patch. Does it metter from the security point of
> view?

Right, the HIDESYM-like feature hasn't been ported by anyone yet, so
this hasn't happened. It would simply build on similar logic.

-Kees

-- 
Kees Cook
Pixel Security
