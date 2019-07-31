Return-Path: <SRS0=RFEU=V4=lists.openwall.com=kernel-hardening-return-16677-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842B9C433FF
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 18:58:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D8FCF214DA
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 18:58:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pzLaZSqD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8FCF214DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16677-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20474 invoked by uid 550); 31 Jul 2019 18:58:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20442 invoked from network); 31 Jul 2019 18:58:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dfwzkRB1EXz9VJ9dIrQ8xrDksaj8jIaBGeToAqjBxZk=;
        b=pzLaZSqD+v/3JZCkSsk26AW9Eo6y04oP3JAgPhEImxaH9ddeYCWVvB8eE6kmMjRI4d
         rt4DHIZa2LTcO2qPndNHSZAro2OhrMCdzmtPEK31DeOSt5fIwBfaagONkrDkPNzNWm0X
         FAtWHZ7xW728jw5/yPivXHvK5zD0DGH8EcceObQX16TopnjWoONXiYxTYxwYLy5d6ksa
         hJ2RX8Xp/YkcGwbbesTaUJd4lP/xgmxynw9hxATOBhfhZDkYWNnjsnX1pcx1kbl+lR0J
         xI+0wdN0jW31N0gb918hny0FGKON0xDN90qzGd49fef5J2qL/OdsiyB1Wp9+Ivy3NLQ8
         eYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dfwzkRB1EXz9VJ9dIrQ8xrDksaj8jIaBGeToAqjBxZk=;
        b=s5fZ8uFODO/G2zFFIige64Jz9p7qZdGk14g8Vyif98Ziua3V0W8qrwdA7Sy2bjUsMY
         p8FhtyLc7Dhxr/7ixsNnyrFK1o5krU38GEx3ZMwpatWwjDi8fSHu6AtHsw5mANg/RPcq
         WkgDLeCjAzRpK2J9TVNZLk3S7spiqFs4y7mt3WegU/QuZZNWS6CW+Sel8z340xc6ZHX6
         NxndJY3LeEEji9rnBLpP6AOBturGGCijQk544q1TKNDHCGurjqHk7ylpDjLz1EcTuzWv
         KO3AXpR9kg5JIhNY5WD+Yh46Dk2uOTgIdmsAEJfXByBMiXM8dpKBDB0GBUvYWEBIWu7u
         XV+A==
X-Gm-Message-State: APjAAAXF6Of83wOn5TurVXHBat83ttwjxHTLgdezF/rFmahdS7hzYvO3
	O1LGB8HnNfGTyBo0Nm2OujrDouy0Xq2Qy1/2qUA=
X-Google-Smtp-Source: APXvYqyFQ94uSoTGnAuzPo6MIkxbHzT0H4KE5R2Xg4xbuewViQmMLg86l+y4c8ByxzzHkTp9v1x+8LRm7BJJaEoAHVg=
X-Received: by 2002:ac2:4351:: with SMTP id o17mr38095219lfl.100.1564599510043;
 Wed, 31 Jul 2019 11:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190721213116.23476-1-mic@digikod.net> <20190721213116.23476-7-mic@digikod.net>
 <20190727014048.3czy3n2hi6hfdy3m@ast-mbp.dhcp.thefacebook.com> <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
In-Reply-To: <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 31 Jul 2019 11:58:18 -0700
Message-ID: <CAADnVQLqkfVijWoOM29PxCL_yK6K0fr8B89r4c5EKgddevJhGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v10 06/10] bpf,landlock: Add a new map type: inode
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	LKML <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Alexei Starovoitov <ast@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>, 
	John Johansen <john.johansen@canonical.com>, Jonathan Corbet <corbet@lwn.net>, 
	Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>, 
	Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, 
	"Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, 
	Tejun Heo <tj@kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, 
	LSM List <linux-security-module@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2019 at 11:46 AM Micka=C3=ABl Sala=C3=BCn
<mickael.salaun@ssi.gouv.fr> wrote:
> >> +    for (i =3D 0; i < htab->n_buckets; i++) {
> >> +            head =3D select_bucket(htab, i);
> >> +            hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
> >> +                    landlock_inode_remove_map(*((struct inode **)l->k=
ey), map);
> >> +            }
> >> +    }
> >> +    htab_map_free(map);
> >> +}
> >
> > user space can delete the map.
> > that will trigger inode_htab_map_free() which will call
> > landlock_inode_remove_map().
> > which will simply itereate the list and delete from the list.
>
> landlock_inode_remove_map() removes the reference to the map (being
> freed) from the inode (with an RCU lock).

I'm going to ignore everything else for now and focus only on this bit,
since it's fundamental issue to address before this discussion can
go any further.
rcu_lock is not a spin_lock. I'm pretty sure you know this.
But you're arguing that it's somehow protecting from the race
I mentioned above?
