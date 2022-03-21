Return-Path: <kernel-hardening-return-21552-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id A2C0FC433F5
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Mar 2022 12:26:36 +0000 (UTC)
Received: (qmail 23568 invoked by uid 550); 21 Mar 2022 12:26:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12156 invoked from network); 21 Mar 2022 09:39:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=7/Wy9X3u24DtTwvR5CuDdNX/jv40fdSQGUPbzFCy4CY=;
        b=IdtcK4ESAv9BjSeYua+7u+8l4qRb/uzglAvhT3xqSpNQbJrgeXKalYgehAFUhRVLd/
         SbDiXqJUSyvz5uACRh6taL6cd6Eur9T+hctaWJmVpOiwPDGUe8D9uv9ZZZ9gV+gYxC4v
         Z6tgCVwZrIQ+DJGoFYPlfiIZjD0exu5w5au6bALn6Vlnlm9QuEEAlK2erRCuxJuj4rKZ
         SsIR9O8lvlrXxXpPNFlPZS9Sz3RDRzuOTlqbJmSIdT3Pm71Po47YHq/S4Ykgb+4N7CaS
         aPp8wvOi+Tm0jsUe7AECfxn6/MfmYrSleFw7+/6dC61i9yYwC/aRg/3GYg3uXHjMe+sV
         fVyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=7/Wy9X3u24DtTwvR5CuDdNX/jv40fdSQGUPbzFCy4CY=;
        b=jCLRDg5vGwWmBnO72M6+1FDZPSLMfqnlu0O0i0dZ9vr8hiYvyZoSNJA+eJNs0cOcS/
         dfkZ9HPdcjZmxcHs/HfJxrizf+AmbdGnZHKRZhnsNdd5BfIvWqdPjtdzXwH9OrlBg5Yj
         1XY18DALdPc8A6XOVSRJf0iU0ZAapfq5oJaDi7cs5CqGNdVQ7VVnCOPKZl1oxGUunLi8
         JJRKP+sjdA4SCeA2z83KFFpwWmqKgfHd9GNEfEiYoiVk16Cj90DEJMkD0Mk40FUurRkn
         47lYXMdfXE9VqfGRkzmoFFtDoaQa9qKBh5xbjjZBJtdKWAn1UgqjjgdExQMAtNiQNEvD
         7/tA==
X-Gm-Message-State: AOAM5330PkEX7fJrQ6F2U8NQNrV3PUYoEUmzUOvSx3dUixFiH/e4wsEf
	hDCYrsA1HOfWEqwqInsAOYAyYZYVAZuCjtmDB5u+0SpO2Y8=
X-Google-Smtp-Source: ABdhPJxkqXIRWzrLroutDVXnmzGMrLLb9jov2S/0MW78vXchh1LGqHJZFHRG4ZKBxjuf3Vh3IJtP6WEZVyoP8qvXY40=
X-Received: by 2002:adf:d1e2:0:b0:204:1a8c:7498 with SMTP id
 g2-20020adfd1e2000000b002041a8c7498mr1384329wrd.530.1647855586036; Mon, 21
 Mar 2022 02:39:46 -0700 (PDT)
MIME-Version: 1.0
From: Marcin Kozlowski <marcinguy@gmail.com>
Date: Mon, 21 Mar 2022 10:39:35 +0100
Message-ID: <CAP6wrbVVK1S+oXHVC6hAs8cRR3XHi31ihBzGHn-rcmE_fUjUVQ@mail.gmail.com>
Subject: OOB accesses in ax88179_rx_fixup() (in USB network card driver) - variants
To: kernel-hardening@lists.openwall.com
Content-Type: multipart/alternative; boundary="000000000000d8d19705dab746dc"

--000000000000d8d19705dab746dc
Content-Type: text/plain; charset="UTF-8"

Hi List,

Don't have much experience and knowledge in that area.

Found this:

https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/commit/?h=usb-linus&id=57bc3d3ae8c14df3ceb4e17d26ddf9eeab304581

Checked out a few drivers code and wondered if anybody did a variant
analysis of this (possibly yes?) However, it seems like Kernel drivers code
for gl620a.c and lg-vl600.c (quick search) don't "Make sure that the bounds
of the metadata array are inside the SKB (and in front of the counter at
the end)."

Example from gl620a.c

https://github.com/torvalds/linux/blob/master/drivers/net/usb/gl620a.c

I think, there is no check for:

/* Make sure that the bounds of the metadata array are inside the SKB
* (and in front of the counter at the end).
*/
if (pkt_cnt * 2 + hdr_off > skb->len)
return 0;

Most likely false positive. Would be great to verify this and learn about
it.

Thanks,
Marcin

--000000000000d8d19705dab746dc
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi List,</div><div><br></div><div>Don&#39;t have much=
 experience and knowledge in that area.</div><div><br></div><div>Found this=
:</div><div><br></div><div><a href=3D"https://git.kernel.org/pub/scm/linux/=
kernel/git/gregkh/usb.git/commit/?h=3Dusb-linus&amp;id=3D57bc3d3ae8c14df3ce=
b4e17d26ddf9eeab304581">https://git.kernel.org/pub/scm/linux/kernel/git/gre=
gkh/usb.git/commit/?h=3Dusb-linus&amp;id=3D57bc3d3ae8c14df3ceb4e17d26ddf9ee=
ab304581</a></div><div><br></div><div>Checked out a few drivers code and <s=
pan class=3D"gmail-css-901oao gmail-css-16my406 gmail-r-poiln3 gmail-r-bcqe=
eo gmail-r-qvutc0">wondered if anybody did a variant analysis of this (poss=
ibly yes?) However, it seems like Kernel drivers code for gl620a.c and lg-v=
l600.c (quick search) don&#39;t &quot;Make sure that the bounds of the meta=
data array are inside the SKB (and in front of the counter at the end).&quo=
t; <br></span></div><div><span class=3D"gmail-css-901oao gmail-css-16my406 =
gmail-r-poiln3 gmail-r-bcqeeo gmail-r-qvutc0"><br></span></div><div><span c=
lass=3D"gmail-css-901oao gmail-css-16my406 gmail-r-poiln3 gmail-r-bcqeeo gm=
ail-r-qvutc0">Example from gl620a.c</span></div><div><span class=3D"gmail-c=
ss-901oao gmail-css-16my406 gmail-r-poiln3 gmail-r-bcqeeo gmail-r-qvutc0"><=
br></span></div><div><span class=3D"gmail-css-901oao gmail-css-16my406 gmai=
l-r-poiln3 gmail-r-bcqeeo gmail-r-qvutc0"><a href=3D"https://github.com/tor=
valds/linux/blob/master/drivers/net/usb/gl620a.c">https://github.com/torval=
ds/linux/blob/master/drivers/net/usb/gl620a.c</a></span></div><div><span cl=
ass=3D"gmail-css-901oao gmail-css-16my406 gmail-r-poiln3 gmail-r-bcqeeo gma=
il-r-qvutc0"><br></span></div><div><span class=3D"gmail-css-901oao gmail-cs=
s-16my406 gmail-r-poiln3 gmail-r-bcqeeo gmail-r-qvutc0">I think, there is n=
o check for:</span></div><div><span class=3D"gmail-css-901oao gmail-css-16m=
y406 gmail-r-poiln3 gmail-r-bcqeeo gmail-r-qvutc0"><br></span></div><div><s=
pan class=3D"gmail-css-901oao gmail-css-16my406 gmail-r-poiln3 gmail-r-bcqe=
eo gmail-r-qvutc0">	/* Make sure that the bounds of the metadata array are =
inside the SKB<br>	 * (and in front of the counter at the end).<br>	 */<br>=
	if (pkt_cnt * 2 + hdr_off &gt; skb-&gt;len)<br>		return 0;</span></div><di=
v><span class=3D"gmail-css-901oao gmail-css-16my406 gmail-r-poiln3 gmail-r-=
bcqeeo gmail-r-qvutc0"><br></span></div><div><span class=3D"gmail-css-901oa=
o gmail-css-16my406 gmail-r-poiln3 gmail-r-bcqeeo gmail-r-qvutc0">Most like=
ly false positive. Would be great to verify this and learn about it.</span>=
</div><div><span class=3D"gmail-css-901oao gmail-css-16my406 gmail-r-poiln3=
 gmail-r-bcqeeo gmail-r-qvutc0"><br></span></div><div><span class=3D"gmail-=
css-901oao gmail-css-16my406 gmail-r-poiln3 gmail-r-bcqeeo gmail-r-qvutc0">=
Thanks,</span></div><div><span class=3D"gmail-css-901oao gmail-css-16my406 =
gmail-r-poiln3 gmail-r-bcqeeo gmail-r-qvutc0">Marcin<br></span></div></div>

--000000000000d8d19705dab746dc--
