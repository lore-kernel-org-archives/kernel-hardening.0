Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BD45F6@IRSMSX102.ger.corp.intel.com>
References: <20160912065318.GH16712@linaro.org> <CAGXu5jL+WXojAYeZB6KWCjXH_L6WnzN9m6kjVy6Lng_yYUzy4g@mail.gmail.com>
 <CAEXv5_htzh3nKjXfRk-ZR1+Q+G_N8PQ=uaOD+CLq3WAPoShrsQ@mail.gmail.com>
 <CAGXu5j+tXen6uop_MJ0hCZ_QpB17g1TEU2T5h9CPFxfTWJ_ZCw@mail.gmail.com> <2236FBA76BA1254E88B949DDB74E612B41BD45F6@IRSMSX102.ger.corp.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 27 Sep 2016 09:46:42 -0700
Message-ID: <CAGXu5jLqWxsJt9LdJn-aBKbpJFjbdLWxJ=W9E4HKDLav-1RcPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: Self introduction
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Liljestrand Hans <hans.liljestrand@aalto.fi>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 26, 2016 at 11:50 PM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
>> Sorry about not communicating better about this.  I started working on
>> v3 (porting to linux-next) a few days ago and have the code moved, but
>> still have to work through a few compile issues.
>>
>> If you're interested in helping, take a look:
>>
>> https://github.com/dwindsor/linux-next/tree/strict-refcount-v3
>>
>> I'll continue working through this, but help would certainly be appreciated.
>
> Hi David!
>
> We have started to work on this about 3 weeks ago and currently have working code with additional tests. Sorry for not letting you know, I guess everyone thought that you are not working on this anymore.
> Just yesterday Hans figured out the proper explanantion for PERCPU_COUNT_BIAS change, so we will be posting series hopefully today-tomorrow after writing better commit messages.

Great! Yeah, I think having verbose and clear commit messages will be
an important part of this series.

-Kees

-- 
Kees Cook
Nexus Security
