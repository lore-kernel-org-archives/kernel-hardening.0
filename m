Return-Path: <SRS0=a0LE=6Z=lists.openwall.com=kernel-hardening-return-18748-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE36C54E4B
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 May 2020 11:12:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7874F206F9
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 May 2020 11:12:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dqT7n9D1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7874F206F9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18748-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13340 invoked by uid 550); 11 May 2020 11:12:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18304 invoked from network); 11 May 2020 05:51:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=0RfzaxWy5NlR52v18fCQ3Eq4Gc9R7EtG+QGtUHyD01c=;
        b=dqT7n9D1Q6uTHb6KDzVjeK5M0rqMjYTTmvR6ZRaM2dw0RIAq4SOX4A9zjQVp4JvqMd
         IT4bJSuw0nXFMgddEVq0voZv6KeA8JOG/g+Du9rAQHlJPNx+VF1HCpSFtxnJEAk/wFPT
         g4NX94/YhYNHWvS224QlWomuHT1ZNrorn2dkLSWj57StpYZqOnl2sYDia47lNnMtr/yf
         TXtC1c0KpzZm8Oj9jWIM1GhBW2VozISop7mNINYs0lHdYsG3SFti+vrgiLBLKvGyQN0t
         XVWw2hP2dwNljjuSY7xnSwA/d7u5dNDWbyTQROXeyURQjzOcHC+iBDeu2c9MDCzRnbki
         I1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=0RfzaxWy5NlR52v18fCQ3Eq4Gc9R7EtG+QGtUHyD01c=;
        b=QoqARj1N0ffYkmu7A9Hnu5Bkc8EIo1MhKO60gcUAEtOd1OxmUThv8dxWRVF/oB9lJc
         krGAnjs+WGphjJxiBa0ispoVfpI11NGQ+z/WDAwzFasCFNDY4jHcHTNaB+OCPS1zSEHg
         FKw3gU2+fD5Pvg3kw51IGCzY0OkIjSncawsmeqlNhPtBHJIDzRRjetvATueu4NGpbctD
         h6nWZ97bfxKks0q7crwSi5uj8iNlRcs6btx8vSN0NIf0Kh/z7sKnFZc3+7v7QJTnW9/T
         vGi9LKqc6rvU9fUxNxwJsyZfj7sMcklnIVkr74O+iJ3Xufnc22DlNnHruwHqiJAfwBKZ
         Z2nw==
X-Gm-Message-State: AGi0PuaSgLT0ATlrnPfCu/Ver+kaDdan4AFJ6w9JZy0TY/PJN2aV+xAk
	Z4K95af8kKOBP+FN3aORD3Xgo//N1DtzhNNOMzg=
X-Google-Smtp-Source: APiQypI4vS/gb55/96sxEtewo1y75/R7OarcfeJiuOhcWExckcTJxLe+NRvUZTPU+EGPUIPCtOPf6cnmsH9aAqgioiY=
X-Received: by 2002:a9f:2b0a:: with SMTP id p10mr10140853uaj.10.1589176272951;
 Sun, 10 May 2020 22:51:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <62f8bcee-ac3c-e344-b95e-18ef86903f55@yahoo.fr>
References: <CAEQi4beJgmNfZ0NsWSHCok9-5H_qLze_sFJ_G=1j8CBz9qi2rQ@mail.gmail.com>
 <62f8bcee-ac3c-e344-b95e-18ef86903f55@yahoo.fr>
From: wzt wzt <wzt.wzt@gmail.com>
Date: Mon, 11 May 2020 13:51:12 +0800
Message-ID: <CAEQi4bfPfkqZH77Ec6UWvMabF+F6PHEpAv74Hv9if5XP=7K3Fw@mail.gmail.com>
Subject: Re: Open source a new kernel harden project
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Content-Type: multipart/alternative; boundary="0000000000003c1d3605a558efe1"

--0000000000003c1d3605a558efe1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

  This mail and previous mail were my personal activities=EF=BC=8CI have do=
ne my
research in spare time=EF=BC=8Cthe name of hksp was given by myself=EF=BC=
=8Cit's not
related to huawei company=EF=BC=8Cthere is no huawei product use these code=
.
 This patch code is raised by me,as one person do not have enough energy to
cover every thing=EF=BC=8Cso there is lack of quality assurance like review=
 and
test. THis patch is just a demo code.
 Thanks you for the issue have found=EF=BC=8Ci am trying to fix the related=
 code.

=E5=9C=A8 2020=E5=B9=B45=E6=9C=8811=E6=97=A5=E6=98=9F=E6=9C=9F=E4=B8=80=EF=
=BC=8CLionel Debroux <lionel_debroux@yahoo.fr> =E5=86=99=E9=81=93=EF=BC=9A
> Hi,
>
>>      This is a new kernel harden project called hksp(huawei kernel
>> self protection),  hope some of the mitigation ideas may help you,
>> thanks.
>>      patch: https://github.com/cloudsec/hksp
>> [...]
> See also
>
https://grsecurity.net/huawei_hksp_introduces_trivially_exploitable_vulnera=
bility
>
>
> Regards,
> Lionel Debroux.
>

--0000000000003c1d3605a558efe1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

 =C2=A0This mail and previous mail were my personal activities=EF=BC=8CI ha=
ve done my research in spare time=EF=BC=8Cthe name of hksp was given by mys=
elf=EF=BC=8Cit&#39;s not related to huawei company=EF=BC=8Cthere is no huaw=
ei product use these code. <br> =C2=A0This patch code is raised by me,as on=
e person do not have enough energy to cover every thing=EF=BC=8Cso there is=
 lack of quality assurance like review and test. THis patch is just a demo =
code. <br> =C2=A0Thanks you for the issue have found=EF=BC=8Ci am trying to=
 fix the related code. <br><br>=E5=9C=A8 2020=E5=B9=B45=E6=9C=8811=E6=97=A5=
=E6=98=9F=E6=9C=9F=E4=B8=80=EF=BC=8CLionel Debroux &lt;<a href=3D"mailto:li=
onel_debroux@yahoo.fr">lionel_debroux@yahoo.fr</a>&gt; =E5=86=99=E9=81=93=
=EF=BC=9A<br>&gt; Hi,<br>&gt;<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 This is a new=
 kernel harden project called hksp(huawei kernel<br>&gt;&gt; self protectio=
n),=C2=A0 hope some of the mitigation ideas may help you,<br>&gt;&gt; thank=
s.<br>&gt;&gt;=C2=A0 =C2=A0 =C2=A0 patch: <a href=3D"https://github.com/clo=
udsec/hksp">https://github.com/cloudsec/hksp</a><br>&gt;&gt; [...]<br>&gt; =
See also<br>&gt; <a href=3D"https://grsecurity.net/huawei_hksp_introduces_t=
rivially_exploitable_vulnerability">https://grsecurity.net/huawei_hksp_intr=
oduces_trivially_exploitable_vulnerability</a><br>&gt;<br>&gt;<br>&gt; Rega=
rds,<br>&gt; Lionel Debroux.<br>&gt;

--0000000000003c1d3605a558efe1--
