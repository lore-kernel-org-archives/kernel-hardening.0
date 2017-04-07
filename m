MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170407152319.f37c877c79c19cb52daf9ba1@linux-foundation.org>
References: <20170406033550.32525-1-ewk@edkovsky.org> <CAGXu5jJ49PZx9T=hTNcFK8sjxLCdp_KBpiFzKLCt1jwj2Q7+3Q@mail.gmail.com>
 <20170407151249.b1d45218ad2f71bdc2c8f992@linux-foundation.org>
 <CAGXu5jJNPbcyYt3=WyM0pceoGpaUc=Nti7aD76uvjmAKwHZ58w@mail.gmail.com> <20170407152319.f37c877c79c19cb52daf9ba1@linux-foundation.org>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 7 Apr 2017 15:47:27 -0700
Message-ID: <CAGXu5jLTzSh2m49cLz+5HC-OpyydX5yQ9tQdjjV6kf7+OB=9jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 0/2] provide check for ro_after_init memory sections
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Eddie Kovsky <ewk@edkovsky.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 7, 2017 at 3:23 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 7 Apr 2017 15:15:36 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> On Fri, Apr 7, 2017 at 3:12 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> > On Fri, 7 Apr 2017 14:53:23 -0700 Kees Cook <keescook@chromium.org> wrote:
>> >
>> >> > Eddie Kovsky (2):
>> >> >   module: verify address is read-only
>> >> >   extable: verify address is read-only
>> >> >
>> >> >  include/linux/kernel.h |  2 ++
>> >> >  include/linux/module.h | 12 ++++++++++++
>> >> >  kernel/extable.c       | 29 +++++++++++++++++++++++++++
>> >> >  kernel/module.c        | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++
>> >> >  4 files changed, 96 insertions(+)
>> >>
>> >> Andrew, do you have these in your mailbox (it went to lkml), or should
>> >> I resend them directly to you? Since they depend on the
>> >> __start_ro_after_init naming fixes in -mm, it seemed like it'd be best
>> >> to carry these two patches there. If so, please consider them both:
>> >>
>> >> Acked-by: Kees Cook <keescook@chromium.org>
>> >>
>> >> (And, from the thread on the module patch, Jessica has Acked that one too.)
>> >
>> > Well I grabbed them, but the patches don't actually do anything - they
>> > add interfaces with no users.  What's the plan here?
>>
>> I'd like to have a way for interfaces (especially the various
>> *_register()) to be able to check that a structure is either const or
>> __ro_after_init. My expectation is to add those and similar
>> sanity-checks now that we can do so.
>
> OK.  But I'd rather sit on the patches until we have working, tested,
> reviewed callers which are agreed to be useful.

That sounds fine to me. Thanks!

-Kees

-- 
Kees Cook
Pixel Security
