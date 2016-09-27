Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEXv5_htzh3nKjXfRk-ZR1+Q+G_N8PQ=uaOD+CLq3WAPoShrsQ@mail.gmail.com>
References: <20160912065318.GH16712@linaro.org> <CAGXu5jL+WXojAYeZB6KWCjXH_L6WnzN9m6kjVy6Lng_yYUzy4g@mail.gmail.com>
 <CAEXv5_htzh3nKjXfRk-ZR1+Q+G_N8PQ=uaOD+CLq3WAPoShrsQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 26 Sep 2016 19:29:25 -0700
Message-ID: <CAGXu5j+tXen6uop_MJ0hCZ_QpB17g1TEU2T5h9CPFxfTWJ_ZCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: Self introduction
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 26, 2016 at 5:29 PM, David Windsor <dave@progbits.org> wrote:
> Hi,
>
>
> On Mon, Sep 26, 2016 at 1:17 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> On Sun, Sep 11, 2016 at 11:53 PM, AKASHI Takahiro
>> <takahiro.akashi@linaro.org> wrote:
>> > Hi Kees and all,
>>
>> Hi! Sorry for not replying sooner -- this email seemed to strangely
>> not make its way into the kernel-hardening list, even though it looks
>> from the headers like you sent it there. Regardless, on to my late
>> reply...
>>
>> > I'm looking for any tasks that I could contribute in
>> > kernel-hardening areas. As I'm working for Linaro,
>> > arm/arm64-related items (or arch-specific implementation
>> > of more generic features) would be better fitted, but I'm
>> > open to broader topics, including complementary tasks
>> > for other guys.
>>
>> Awesome! Yeah, it'll be great to have you helping. Are there any areas
>> you especially enjoy working on?
>>
>> > Do you have any suggestions about such items for me
>> > to start small (or can be even big :) with?
>>
>> I think a great area would be looking at arm and arm64 support for
>> catching atomic_t wrap-around. This kind of protection would have
>> stopped many of the public attacks from last year, since accidents
>> with refcounting on atomic_t tend to be a precursor to use-after-free
>> vulnerabilities.
>>
>> This idea has been implemented in PaX/Grsecurity for a while now as
>> PAX_REFCOUNT. An earlier effort to extract it was started but he ran
>> out of time to work on it.
>
>
> Sorry about not communicating better about this.  I started working on v3
> (porting to linux-next) a few days ago and have the code moved, but still
> have to work through a few compile issues.
>
> If you're interested in helping, take a look:
>
> https://github.com/dwindsor/linux-next/tree/strict-refcount-v3
>
> I'll continue working through this, but help would certainly be appreciated.

No worries, thanks for the heads-up! I think getting everyone on the
same page will be good. We can all compare notes when Intel posts
patches too.

-Kees

-- 
Kees Cook
Nexus Security
