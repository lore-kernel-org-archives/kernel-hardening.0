Return-Path: <kernel-hardening-return-21582-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id BC72EC4332F
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Nov 2022 14:54:08 +0000 (UTC)
Received: (qmail 3901 invoked by uid 550); 8 Nov 2022 14:53:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3855 invoked from network); 8 Nov 2022 14:53:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=md7pq5Y61523ftXLUcPOT58RE3lJ/xJd5Ph3p8iEops=;
        b=ZXZdWEAL1R1ZVFA2P8fuWqcX2rj1JRkf1sp5+gC2XB9VDMVOHlyvW06sVoWrr0JeLS
         tvUZupelkiZrBGHM4LVCUF9TJL0PrccBEvLQqTWDh37RAs+5ZOMQgNgQqZsVeWWTWl20
         pPi2oeRzwQuqwhUBo7egz7jaC5Dx7kiLJrTQYY5RUrSmxRyaebac4H7gxtQ5lFDXRHkr
         sDxMbEHOoBWiIPdLSayctyrYpXiHkqYZePXrc4vmmPCakZrhLAjrSdNFi/rT/bSfGjk/
         fEaa/X6uGH57UhEHgRxznmXcajiDWhf0/RsixaCP39jbo00AGUVbCIRsqQ9c6UeYwnW5
         V0mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=md7pq5Y61523ftXLUcPOT58RE3lJ/xJd5Ph3p8iEops=;
        b=QFTJUqUKZa815dAejdityi5KRtM8sXa7K9E0JfoZ5lz92J+UqfN5/NMuVd9uH1EhF9
         eWD9NYdlfhqUtnn/i0q0Bpz6XGRJGBrsmPujX0Sk4ervVpdAH9ExXuV0oRP3GUy2yAM7
         OavDV7NCb8BxLCA431sRqUoyZLFai6q+zV9ED3JMrroYSREElHbuDMpIK/e4n22O7XEd
         UgkKSHuqA0yNYe4nM5XYxN2FmZBkj1wf0fwRm5m52uuXMbYepLV304hXprxUNHnk10rR
         54S7y4N08jhMVMaBkBzHay4zLLsgLw3c6JZmivUtJbutv3M3fwVtQOv6X1EZ2aFzicAt
         1F6Q==
X-Gm-Message-State: ANoB5pnpUiCDvVQ51ja0P+gBUE5QMYUQIMNPRvcFV5a4SnsBwwVEHru7
	n6PCBHolHVIEAyym6EuWsdoDfJflc5H9IfNDxpq/UA==
X-Google-Smtp-Source: AA0mqf64FMOjlHNu2kF5bZaWRJmb+rAcbAEZwyePMAW3WnAc6couRpYkD7fasQW1Ra9c+tlJUfPYQqMoNMGd+ru8XS8=
X-Received: by 2002:a6b:b80a:0:b0:6dd:3f5a:32d6 with SMTP id
 i10-20020a6bb80a000000b006dd3f5a32d6mr2104168iof.154.1667919223019; Tue, 08
 Nov 2022 06:53:43 -0800 (PST)
MIME-Version: 1.0
References: <20221107201317.324457-1-jannh@google.com> <3e2f7e2cb4f6451a9ef5d0fb9e1f6080@AcuMS.aculab.com>
In-Reply-To: <3e2f7e2cb4f6451a9ef5d0fb9e1f6080@AcuMS.aculab.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 8 Nov 2022 15:53:07 +0100
Message-ID: <CAG48ez3AGh-R+deQMbNPt6PCQazOz8a96skW+qP3_HmUaANmmQ@mail.gmail.com>
Subject: Re: [PATCH] exit: Put an upper limit on how often we can oops
To: David Laight <David.Laight@aculab.com>
Cc: Kees Cook <keescook@chromium.org>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, Seth Jenkins <sethjenkins@google.com>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 8, 2022 at 10:26 AM David Laight <David.Laight@aculab.com> wrote:
> > Many Linux systems are configured to not panic on oops; but allowing an
> > attacker to oops the system **really** often can make even bugs that look
> > completely unexploitable exploitable (like NULL dereferences and such) if
> > each crash elevates a refcount by one or a lock is taken in read mode, and
> > this causes a counter to eventually overflow.
> >
> > The most interesting counters for this are 32 bits wide (like open-coded
> > refcounts that don't use refcount_t). (The ldsem reader count on 32-bit
> > platforms is just 16 bits, but probably nobody cares about 32-bit platforms
> > that much nowadays.)
> >
> > So let's panic the system if the kernel is constantly oopsing.
>
> I think you are pretty much guaranteed to run out of memory
> (or at least KVA) before any 32bit counter wraps.

Not if you repeatedly take a reference and then oops without dropping
the reference, and the oops path cleans up all the resources that were
allocated for the crashing tasks. In that case, each oops increments
the reference count by 1 without causing memory allocation.

(Also, as a sidenote: To store 2^32 densely packed pointers, you just
need around 8 bytes * (2^32) = 32 GiB of RAM. So on a workstation or
server with a decent amount of RAM, there can already be cases where
you can overflow a 32-bit reference counter with legitimate references
- see <https://bugs.chromium.org/p/project-zero/issues/detail?id=809>.
Another example that needs more RAM is
<https://bugs.chromium.org/p/project-zero/issues/detail?id=1752>, that
needs ~140 GiB. Still probably within the realm of what a beefy server
might have nowadays? Kernel virtual address space is not a meaningful
limit on x86-64 - even with 4-level paging, the kernel has a 64 TiB
virtual memory area (the direct mapping) that is used for slab
allocations and such, see
<https://www.kernel.org/doc/html/latest/x86/x86_64/mm.html>. With
5-level paging it's even more, 32 PiB.)
