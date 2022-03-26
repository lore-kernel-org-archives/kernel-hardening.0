Return-Path: <kernel-hardening-return-21556-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id A83DFC433EF
	for <kernel-hardening@archiver.kernel.org>; Sat, 26 Mar 2022 20:41:39 +0000 (UTC)
Received: (qmail 32034 invoked by uid 550); 26 Mar 2022 20:41:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28556 invoked from network); 26 Mar 2022 17:09:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=RF71MgXr7XLir91b3I4VYxGxZr546UWotKTvj0iechM=;
        b=MwsR1yqct2uFqZuUZp4IqsQEUK6JqHdrTc7ZAG4BAXRt6N8Ujb3J7Awi81Fr8XfEN+
         t45I8KQ0aMh21VlIrtnJ/w5p2GAfBeUIT68AHJPSzRkiEGbCqGIC7e5L5n/nIdFRWF8s
         IdmIwZ+8Pd+HjJnjT3Sl0k4Pj98fWKEsyT6LpQafvPJx2AM2C+AAKaJBZGYh996xgCUg
         boYXN6KXcXNmcIUV/Uj0StGELHhpvE4Aa6ftlTbafnFgaG8mAwdPVtcMv1SHxUmSnGNz
         wu4nqcJhDcPBmqvZgDdyY491SiSHGkP5cQf8Jdnp3NRAYpZT8NygQX5TeSRX7p3eon3e
         nx8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=RF71MgXr7XLir91b3I4VYxGxZr546UWotKTvj0iechM=;
        b=K+j8Cxhn65HW0pYlGkZigFJI3bZwAeYCL3SZEjwKA0Rr05tG8sLFfYXBs7nioFx/YW
         Zm2O/NRl8REnZCJzrKgWR555RBWHWq2Elo0tKGlCArcjEcdfYWjUe8yJuVurynt7WHaA
         Od6hiU4M21gbFNVRpfqbp3h6vdG+iQAKctQthQbxus7BPSd/+9AQqiaqTS0LdFN/Nj6U
         V2Eym4GIyj9Ymi5z/cLIWVcuFltPV6QnmllRXDffPTDzdYL67X3yU+0id6AbjE/PiToR
         hZMALa7gEPPTDEL2VBwHjsc+7rXl3oya0BfNlT25RHeDQLHen4QpUM5uZoVEdv8qE+OW
         OlfA==
X-Gm-Message-State: AOAM530mNIolkStzAftch7SuQDuHFj9lAYDqgl6YObDipQsW2MK7MxrT
	7Qx+DFdXKDvF4gpSmyHXhNqNhySLJ7OYSqqeFEF537Wz
X-Google-Smtp-Source: ABdhPJyyYqG9Co2OWYqNE7k1bKvWRdTbF3073TLmJBMNYBCSxtxsMtAgCg2OQmnPRDMptkgQQMHbkl171n+HHZbxHy4=
X-Received: by 2002:adf:f946:0:b0:1f0:62c3:ea2e with SMTP id
 q6-20020adff946000000b001f062c3ea2emr13922132wrr.348.1648314558327; Sat, 26
 Mar 2022 10:09:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAP6wrbVVK1S+oXHVC6hAs8cRR3XHi31ihBzGHn-rcmE_fUjUVQ@mail.gmail.com>
In-Reply-To: <CAP6wrbVVK1S+oXHVC6hAs8cRR3XHi31ihBzGHn-rcmE_fUjUVQ@mail.gmail.com>
From: Marcin Kozlowski <marcinguy@gmail.com>
Date: Sat, 26 Mar 2022 18:09:11 +0100
Message-ID: <CAP6wrbUVPSEUTm7JkL=zv6nzxRbAr=jNPo9ZPBA-_AXz7yCeKQ@mail.gmail.com>
Subject: Re: OOB accesses in ax88179_rx_fixup() (in USB network card driver) - variants
To: kernel-hardening@lists.openwall.com
Content-Type: multipart/alternative; boundary="000000000000ba2ce205db222353"

--000000000000ba2ce205db222353
Content-Type: text/plain; charset="UTF-8"

gl620a.c is some usb to usb computer cable, and lg-vl600.c a usb 4g dongle.
Both drivers seem NOT to use skb metadata (they take packet len and count
from skb->data directly).

Why would ASIX driver use metadata and others (those 2) don't?

Could not find any info on skb Metadata.

Thanks,

Marcin

On Mon, 21 Mar 2022, 10:39 Marcin Kozlowski <marcinguy@gmail.com> wrote:

> Hi List,
>
> Don't have much experience and knowledge in that area.
>
> Found this:
>
>
> https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/commit/?h=usb-linus&id=57bc3d3ae8c14df3ceb4e17d26ddf9eeab304581
>
> Checked out a few drivers code and wondered if anybody did a variant
> analysis of this (possibly yes?) However, it seems like Kernel drivers code
> for gl620a.c and lg-vl600.c (quick search) don't "Make sure that the bounds
> of the metadata array are inside the SKB (and in front of the counter at
> the end)."
>
> Example from gl620a.c
>
> https://github.com/torvalds/linux/blob/master/drivers/net/usb/gl620a.c
>
> I think, there is no check for:
>
> /* Make sure that the bounds of the metadata array are inside the SKB
> * (and in front of the counter at the end).
> */
> if (pkt_cnt * 2 + hdr_off > skb->len)
> return 0;
>
> Most likely false positive. Would be great to verify this and learn about
> it.
>
> Thanks,
> Marcin
>

--000000000000ba2ce205db222353
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><p dir=3D"ltr">gl<a href=3D"tel:620">620</a>a.c is some u=
sb to usb computer cable, and lg-vl<a href=3D"tel:600">600</a>.c a usb 4g d=
ongle. Both drivers seem NOT to use skb metadata (they take packet len and =
count from skb-&gt;data directly).</p><p dir=3D"ltr">Why would ASIX driver =
use metadata and others (those 2) don&#39;t?=C2=A0</p><p dir=3D"ltr">Could =
not find any info on skb Metadata.<br></p><p dir=3D"ltr">Thanks,=C2=A0</p><=
p dir=3D"ltr">Marcin</p></div><br><div class=3D"gmail_quote"><div dir=3D"lt=
r" class=3D"gmail_attr">On Mon, 21 Mar 2022, 10:39 Marcin Kozlowski &lt;<a =
href=3D"mailto:marcinguy@gmail.com">marcinguy@gmail.com</a>&gt; wrote:<br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-le=
ft:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div>Hi List,</div><di=
v><br></div><div>Don&#39;t have much experience and knowledge in that area.=
</div><div><br></div><div>Found this:</div><div><br></div><div><a href=3D"h=
ttps://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/commit/?h=3Du=
sb-linus&amp;id=3D57bc3d3ae8c14df3ceb4e17d26ddf9eeab304581" target=3D"_blan=
k" rel=3D"noreferrer">https://git.kernel.org/pub/scm/linux/kernel/git/gregk=
h/usb.git/commit/?h=3Dusb-linus&amp;id=3D57bc3d3ae8c14df3ceb4e17d26ddf9eeab=
304581</a></div><div><br></div><div>Checked out a few drivers code and <spa=
n>wondered if anybody did a variant analysis of this (possibly yes?) Howeve=
r, it seems like Kernel drivers code for gl620a.c and lg-vl600.c (quick sea=
rch) don&#39;t &quot;Make sure that the bounds of the metadata array are in=
side the SKB (and in front of the counter at the end).&quot; <br></span></d=
iv><div><span><br></span></div><div><span>Example from gl620a.c</span></div=
><div><span><br></span></div><div><span><a href=3D"https://github.com/torva=
lds/linux/blob/master/drivers/net/usb/gl620a.c" target=3D"_blank" rel=3D"no=
referrer">https://github.com/torvalds/linux/blob/master/drivers/net/usb/gl6=
20a.c</a></span></div><div><span><br></span></div><div><span>I think, there=
 is no check for:</span></div><div><span><br></span></div><div><span>	/* Ma=
ke sure that the bounds of the metadata array are inside the SKB<br>	 * (an=
d in front of the counter at the end).<br>	 */<br>	if (pkt_cnt * 2 + hdr_of=
f &gt; skb-&gt;len)<br>		return 0;</span></div><div><span><br></span></div>=
<div><span>Most likely false positive. Would be great to verify this and le=
arn about it.</span></div><div><span><br></span></div><div><span>Thanks,</s=
pan></div><div><span>Marcin<br></span></div></div>
</blockquote></div>

--000000000000ba2ce205db222353--
