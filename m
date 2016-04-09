Reply-To: kernel-hardening@lists.openwall.com
References: <1460138602-85386-1-git-send-email-thgarnie@google.com>
 <57090CDE.6080509@gmail.com>
 <CAJcbSZGo25eo4-ukF39vNvvpdzpmnQY6RVBcxc41Z-goS5F1LA@mail.gmail.com>
From: lazytyped <lazytyped@gmail.com>
Message-ID: <570914BA.8020308@gmail.com>
Date: Sat, 9 Apr 2016 07:42:02 -0700
MIME-Version: 1.0
In-Reply-To: <CAJcbSZGo25eo4-ukF39vNvvpdzpmnQY6RVBcxc41Z-goS5F1LA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC v2] mm: SLAB freelist randomization
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 4/9/16 7:24 AM, Thomas Garnier wrote:
>
> Yes and no. With slabinfo not being available if not root you are not
> sure when you start a new SLAB. You also can't quantify the risk of
> another allocation happening on a real machine under load.
>
> It decreases the odds on a successful overflow that just requires two
> allocations to follow one another. It doesn't mitigate heap overflows.
>

Both things you mention above are somehow unrelated to the freelist
randomization. But that's fine. This has no performance impact, so there
is no problem in having it (not that I would or would want to have a say
:-) ).

I was just arguing that hinting at that specific exploit as one that
would have had 'decreased' odds of exploitation didn't seem like the
best choice.


        -  twiz
