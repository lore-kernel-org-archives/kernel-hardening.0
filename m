MIME-Version: 1.0
In-Reply-To: <20171127131828.GA16939@openwall.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <20171127011441.GA15063@openwall.com> <20171127131828.GA16939@openwall.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Thu, 30 Nov 2017 15:38:11 +0100
Message-ID: <CAJHCu1LXh1eGu1cm+y28LC=hnvNRnkeS+a-QdFFwvVWuSWymuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 0/2] Restrict dangerous open in sticky directories
To: Solar Designer <solar@openwall.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-11-27 14:18 GMT+01:00 Solar Designer <solar@openwall.com>:
> Salvatore,
>
> On Mon, Nov 27, 2017 at 02:14:41AM +0100, Solar Designer wrote:
>> When I suggested the O_CREAT-without-O_EXCL checks, I didn't mean you'd
>> try to introduce them at the same time with the restrictions on FIFOs
>> and regular files.
>
> I re-read what I wrote in that discussion in September, and I can see
> how it was confusing: first I suggested those checks as possible extra
> settings in the restrictions on FIFOs and regular files, then agreed
> with you that we need a separate sysctl in a separate patch - but we
> never discussed whether that separate patch should be part of the same
> patch series or not.

No problem, misunderstandings happen.
I really appreciate your help with this patch!

Salvatore
