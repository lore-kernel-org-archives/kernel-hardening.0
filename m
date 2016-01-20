Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1453323437.6344.32.camel@debian.org>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
	<CAGXu5jJJ13z206L6R99MYmiUA7hVYUJC5UVS8h5Mg0sUDr60GQ@mail.gmail.com>
	<CAGXu5jLsxwhrgyRfvYV79WJrrFr9tkXMe=7-qWBz6VWEsEA_5g@mail.gmail.com>
	<1453323437.6344.32.camel@debian.org>
Date: Wed, 20 Jan 2016 15:39:10 -0800
Message-ID: <CAGXu5jLYOYZ2Tbvp3kVbOAD8WCqYgPTwLF7acfqZB0qATSNT8w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening][RFC PATCH v2 00/12] Add PAX_REFCOUNT overflow protection
To: Yves-Alexis Perez <corsac@debian.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 20, 2016 at 12:57 PM, Yves-Alexis Perez <corsac@debian.org> wrote:
> On mar., 2016-01-19 at 11:07 -0800, Kees Cook wrote:
>> Hi David,
>>
>> On Thu, Dec 17, 2015 at 12:55 PM, Kees Cook <keescook@chromium.org> wrote:
>> > On Thu, Dec 17, 2015 at 6:57 AM, David Windsor <dave@progbits.org> wrote:
>> > > NOTE: This is a v2 submission because patch 3/5 in v1 was too large to
>> > > sent
>> > > to kernel-hardening.  Taking that as a sign that the patch needed to be
>> > > split,
>> > > I'm sending this version of the patchset, with the patches split more or
>> > > less
>> > > on a per-maintainer basis (except for those in drivers/).
>>
>> How's the next spin coming? It looks like we have some new real-world
>> examples of exploits that would have been blocked by this protection:
>>
>> http://perception-point.io/2016/01/14/analysis-and-exploitation-of-a-linux-k
>> ernel-vulnerability-cve-2016-0728/
>>
>>
> One thing which is surprising (I have to admit I'm not really an expert on how
> SLAB works) is how easy it apparently is to have multiple allocations end up
> at the same place. You don't even have to *know* the exact address.
>
> Wouldn't it be possible to at least have some randomization here, so new
> object are not at the same place as the not-freed-ones, somehow preventing the
> use-after-free and forcing an attacker to do some heap massaging?

Yeah, it could be worth doing. Maybe Laura will want to take a stab at
this after the sanitization series is done?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
