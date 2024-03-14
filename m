Return-Path: <kernel-hardening-return-21726-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 81BBFC54E60
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 Mar 2024 21:03:28 +0000 (UTC)
Received: (qmail 23613 invoked by uid 550); 14 Mar 2024 20:59:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23574 invoked from network); 14 Mar 2024 20:59:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sempervictus-com.20230601.gappssmtp.com; s=20230601; t=1710450190; x=1711054990; darn=lists.openwall.com;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AzuHIDVnpodvf8Yk4kbRsSjN+JkysTBQ+d66KpBJz9I=;
        b=HmhogfSOD3nUcavJezU1pOgyD3WuS42O7abuf/4y3IdOGsErHLnUQr+aEli38KlXwj
         TfqJxl/mh8ZxGvlXZZd4bIHvn1y9zsoFZNhDbCFq69QwU8tdAjZeyozssTnpcbBV9vIw
         morx7PGqDzsJwMP1zZjiWp3oeFO1n4ee959nf5sUcXkJV+xeBOup67SY/wdY3g3NbmMR
         7+w0dCf5SdFdydxtB0GT7Hrp86BMd8vczbxu4Ob0E9gv3z1CNq4c6a8VQkreIXtQejxe
         EEdYWNKY1+7+KQmQminKEBDorvA8ILUTGk7N61EX7btzUlh5bZ7EXvL31aIiEDF0w3Yd
         CTrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710450190; x=1711054990;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AzuHIDVnpodvf8Yk4kbRsSjN+JkysTBQ+d66KpBJz9I=;
        b=BMTYxKG+Bb/+VHis5q2apubM6CvOD8AjHE/odYdRFM3huZw04tx7v5OQ/LT2vVMir5
         SdtKg/ov6tXouGKjzcyAk9sGhlTdCFu3Sg4pmFSf+DwgXmpt9bQ3aFC2zzM6cFBrjB9C
         DtsgfaiUqmG5JsfRgfUNjbvxtfLKfJKbuWHilXqv9yWmr6R+Ltg6OBxZXgUwZF3lOr9l
         0xmqdLnNCcApCky77SrAz3pbuEZ9PLj7HktnAIRGXCZThXJChd+WilubfnIyS+3z7vJt
         Bck2WVQ3v496IN3vQjtuD+yExOjbbgs4ot7CMocAjU/huI/atV9X/oXfsRSKiBFdDc06
         N+mw==
X-Forwarded-Encrypted: i=1; AJvYcCUSPaqHj1foCXMXH4RDLeyjxEABR2bMKuXovzGfrm3E2Inl3Ql5+2whPAY8vcysbFEjTkArqN2x1B5UIcCXAVfsH6Snr4VES0CegQq3agZPvkHLmw==
X-Gm-Message-State: AOJu0YzXW7b4fgJA1bw3hPzDhB9yleirhoMVI3nQ3SXZbFV+OzGV/DBm
	Az7r7wzMCDmYeVn8Bu+TFcgOvdHEz6RiUkOYzvPGqLCfa7MtoEytuw3Yg6YY3Y7SJXZas3DYwRt
	m3do43yaz8Utbvj38kUflIaJh6xg12w0zIgRlzJdt+US2RTSuYtM=
X-Google-Smtp-Source: AGHT+IGMBFRkxWjovdYSwAgw4fKNsLNeovNhukMUMNExBSIAMrIyRb0al87GLoaAFe3JL0D53s8FU083uXXQJmIWDdM=
X-Received: by 2002:a25:aaec:0:b0:dc2:40d8:ac5e with SMTP id
 t99-20020a25aaec000000b00dc240d8ac5emr3170960ybi.1.1710450189781; Thu, 14 Mar
 2024 14:03:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
 <202403140927.5A5F290@keescook> <3b3c941f1fb69d67706457a30cecc96bfde57353.camel@intel.com>
 <65f3412e598c8_13f3a29410@iweiny-mobl.notmuch>
In-Reply-To: <65f3412e598c8_13f3a29410@iweiny-mobl.notmuch>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Thu, 14 Mar 2024 17:02:58 -0400
Message-ID: <CAFUG7CfTETMzj2ofF+jmUxRrtbEhNDO7U5N0ftKbA8_t6WS2-w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/19] PKS write protected page tables
To: Ira Weiny <ira.weiny@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"keescook@chromium.org" <keescook@chromium.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "luto@kernel.org" <luto@kernel.org>, 
	"Hansen, Dave" <dave.hansen@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "peterz@infradead.org" <peterz@infradead.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "rppt@kernel.org" <rppt@kernel.org>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, 
	"shakeelb@google.com" <shakeelb@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, 
	"ardb@google.com" <ardb@google.com>
Content-Type: multipart/alternative; boundary="000000000000f7ef5e0613a537e6"

--000000000000f7ef5e0613a537e6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

IIRC shoot-downs are one of the reasons for using per-cpu PGDs which would
be a hard sell to some people.
https://forum.osdev.org/viewtopic.php?f=3D15&t=3D29661

-Boris

On Thu, Mar 14, 2024 at 2:26=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wro=
te:

> Edgecombe, Rick P wrote:
> > On Thu, 2024-03-14 at 09:27 -0700, Kees Cook wrote:
> > > On Mon, Aug 30, 2021 at 04:59:08PM -0700, Rick Edgecombe wrote:
> > > > This is a second RFC for the PKS write protected tables concept.
> > > > I'm sharing to
> > > > show the progress to interested people. I'd also appreciate any
> > > > comments,
> > > > especially on the direct map page table protection solution (patch
> > > > 17).
> > >
> > > *thread necromancy*
> > >
> > > Hi,
> > >
> > > Where does this series stand? I don't think it ever got merged?
> >
> > There are sort of three components to this:
> > 1. Basic PKS support. It was dropped after the main use case was
> > rejected (pmem stray write protection).
>
> This was the main reason it got dropped.
>
> > 2. Solution for applying direct map permissions efficiently. This
> > includes avoiding excessive kernel shootdowns, as well as avoiding
> > direct map fragmentation. rppt continued to look at the fragmentation
> > part of the problem and ended up arguing that it actually isn't an
> > issue [0]. Regardless, the shootdown problem remains for usages like
> > PKS tables that allocate so frequently. There is an attempt to address
> > both in this series. But given the above, there may be lots of debate
> > and opinions.
> > 3. The actual protection of the PKS tables (most of this series). It
> > got paused when I started to work on CET. In the meantime 1 was
> > dropped, and 2 is still open(?). So there is more to work through now,
> > then when it was dropped.
> >
> > If anyone wants to pick it up, it is fine by me. I can help with
> > reviews.
>
> I can help with reviews as well,
> Ira
>
> >
> >
> > [0] https://lwn.net/Articles/931406/
>
>
>

--=20
Boris Lukashev
Systems Architect
Semper Victus <https://www.sempervictus.com>

--000000000000f7ef5e0613a537e6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>IIRC shoot-downs are one of the reasons for using per=
-cpu PGDs which would be a hard sell to some people.</div><div><a href=3D"h=
ttps://forum.osdev.org/viewtopic.php?f=3D15&amp;t=3D29661">https://forum.os=
dev.org/viewtopic.php?f=3D15&amp;t=3D29661</a></div><div><br></div><div>-Bo=
ris<br></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D=
"gmail_attr">On Thu, Mar 14, 2024 at 2:26=E2=80=AFPM Ira Weiny &lt;<a href=
=3D"mailto:ira.weiny@intel.com">ira.weiny@intel.com</a>&gt; wrote:<br></div=
><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border=
-left:1px solid rgb(204,204,204);padding-left:1ex">Edgecombe, Rick P wrote:=
<br>
&gt; On Thu, 2024-03-14 at 09:27 -0700, Kees Cook wrote:<br>
&gt; &gt; On Mon, Aug 30, 2021 at 04:59:08PM -0700, Rick Edgecombe wrote:<b=
r>
&gt; &gt; &gt; This is a second RFC for the PKS write protected tables conc=
ept.<br>
&gt; &gt; &gt; I&#39;m sharing to<br>
&gt; &gt; &gt; show the progress to interested people. I&#39;d also appreci=
ate any<br>
&gt; &gt; &gt; comments,<br>
&gt; &gt; &gt; especially on the direct map page table protection solution =
(patch<br>
&gt; &gt; &gt; 17).<br>
&gt; &gt; <br>
&gt; &gt; *thread necromancy*<br>
&gt; &gt; <br>
&gt; &gt; Hi,<br>
&gt; &gt; <br>
&gt; &gt; Where does this series stand? I don&#39;t think it ever got merge=
d?<br>
&gt; <br>
&gt; There are sort of three components to this:<br>
&gt; 1. Basic PKS support. It was dropped after the main use case was<br>
&gt; rejected (pmem stray write protection).<br>
<br>
This was the main reason it got dropped.<br>
<br>
&gt; 2. Solution for applying direct map permissions efficiently. This<br>
&gt; includes avoiding excessive kernel shootdowns, as well as avoiding<br>
&gt; direct map fragmentation. rppt continued to look at the fragmentation<=
br>
&gt; part of the problem and ended up arguing that it actually isn&#39;t an=
<br>
&gt; issue [0]. Regardless, the shootdown problem remains for usages like<b=
r>
&gt; PKS tables that allocate so frequently. There is an attempt to address=
<br>
&gt; both in this series. But given the above, there may be lots of debate<=
br>
&gt; and opinions.<br>
&gt; 3. The actual protection of the PKS tables (most of this series). It<b=
r>
&gt; got paused when I started to work on CET. In the meantime 1 was<br>
&gt; dropped, and 2 is still open(?). So there is more to work through now,=
<br>
&gt; then when it was dropped.<br>
&gt; <br>
&gt; If anyone wants to pick it up, it is fine by me. I can help with<br>
&gt; reviews.<br>
<br>
I can help with reviews as well,<br>
Ira<br>
<br>
&gt; <br>
&gt; <br>
&gt; [0] <a href=3D"https://lwn.net/Articles/931406/" rel=3D"noreferrer" ta=
rget=3D"_blank">https://lwn.net/Articles/931406/</a><br>
<br>
<br>
</blockquote></div><br clear=3D"all"><br><span class=3D"gmail_signature_pre=
fix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><div dir=3D"l=
tr"><div><div dir=3D"ltr"><div><div dir=3D"ltr">Boris Lukashev<br>Systems A=
rchitect<br><a href=3D"https://www.sempervictus.com" target=3D"_blank">Semp=
er Victus</a><br></div></div></div></div></div></div>

--000000000000f7ef5e0613a537e6--
