Return-Path: <SRS0=GGoY=V4=lists.openwall.com=kernel-hardening-return-16678-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BB5C32751
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 19:11:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 48D4E2067D
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 19:11:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ssi.gouv.fr header.i=@ssi.gouv.fr header.b="K+A6FnWZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48D4E2067D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ssi.gouv.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16678-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30389 invoked by uid 550); 31 Jul 2019 19:11:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30357 invoked from network); 31 Jul 2019 19:11:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ssi.gouv.fr;
	s=20160407; t=1564600272;
	bh=SfyOReVnNROKfZwttu5Z/yffmm1NmOYb+Llaggymyc8=;
	h=Subject:To:CC:References:From:Date:In-Reply-To:From:Subject;
	b=K+A6FnWZ2vYNRnksB4DVngotvdOUnevIk1RgwU8g3acfbqfGiL+9aaVddGfaKtmBd
	 uyGl5LKbVpIhgAmJATK1quDSGs/yrgbPD3vZypBh4eV1IOprFYM3TcN6fCpGP9iwB+
	 buoLb8CFqVJFSQ9t3CGsOa6QfT35DGjx3zKHlWnjzdizlRyxmuvGdEzBXKzNTImfS4
	 cbUnlvyRDylsexMyiSnZRHK49fG+hix0qdkrLm+QnPmLjw5OT9wfojYgHZ51zZDP9x
	 YnTpRJDKUpZCNREaLFcyHUZZF4CznTLXSlXhyqbiErIEHjFrPFCNMVTaaGnCDp/VpT
	 qQQB+ogiJJWUQ==
Subject: Re: [PATCH bpf-next v10 06/10] bpf,landlock: Add a new map type:
 inode
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, LKML
	<linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexei Starovoitov <ast@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo
 Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>,
	Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>,
	"David S . Miller" <davem@davemloft.net>, "Eric W . Biederman"
	<ebiederm@xmission.com>, James Morris <jmorris@namei.org>, Jann Horn
	<jann@thejh.net>, John Johansen <john.johansen@canonical.com>, Jonathan
 Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Michael Kerrisk
	<mtk.manpages@gmail.com>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon
	<sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan
	<shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo
	<tj@kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Thomas
 Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Will Drewry
	<wad@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>, Linux-Fsdevel
	<linux-fsdevel@vger.kernel.org>, LSM List
	<linux-security-module@vger.kernel.org>, Network Development
	<netdev@vger.kernel.org>
References: <20190721213116.23476-1-mic@digikod.net>
 <20190721213116.23476-7-mic@digikod.net>
 <20190727014048.3czy3n2hi6hfdy3m@ast-mbp.dhcp.thefacebook.com>
 <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
 <CAADnVQLqkfVijWoOM29PxCL_yK6K0fr8B89r4c5EKgddevJhGQ@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>
Message-ID: <59e8fab9-34df-0ebe-ca6b-8b34bf582b75@ssi.gouv.fr>
Date: Wed, 31 Jul 2019 21:11:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:52.0) Gecko/20100101
 Thunderbird/52.9.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQLqkfVijWoOM29PxCL_yK6K0fr8B89r4c5EKgddevJhGQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 31/07/2019 20:58, Alexei Starovoitov wrote:
> On Wed, Jul 31, 2019 at 11:46 AM Micka=C3=ABl Sala=C3=BCn
> <mickael.salaun@ssi.gouv.fr> wrote:
>>>> +    for (i =3D 0; i < htab->n_buckets; i++) {
>>>> +            head =3D select_bucket(htab, i);
>>>> +            hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
>>>> +                    landlock_inode_remove_map(*((struct inode **)l->k=
ey), map);
>>>> +            }
>>>> +    }
>>>> +    htab_map_free(map);
>>>> +}
>>>
>>> user space can delete the map.
>>> that will trigger inode_htab_map_free() which will call
>>> landlock_inode_remove_map().
>>> which will simply itereate the list and delete from the list.
>>
>> landlock_inode_remove_map() removes the reference to the map (being
>> freed) from the inode (with an RCU lock).
>
> I'm going to ignore everything else for now and focus only on this bit,
> since it's fundamental issue to address before this discussion can
> go any further.
> rcu_lock is not a spin_lock. I'm pretty sure you know this.
> But you're arguing that it's somehow protecting from the race
> I mentioned above?
>

I was just clarifying your comment to avoid misunderstanding about what
is being removed.

As said in the full response, there is currently a race but, if I add a
bpf_map_inc() call when the map is referenced by inode->security, then I
don't see how a race could occur because such added map could only be
freed in a security_inode_free() (as long as it retains a reference to
this inode).


--
Micka=C3=ABl Sala=C3=BCn
ANSSI/SDE/ST/LAM

Les donn=C3=A9es =C3=A0 caract=C3=A8re personnel recueillies et trait=C3=A9=
es dans le cadre de cet =C3=A9change, le sont =C3=A0 seule fin d=E2=80=99ex=
=C3=A9cution d=E2=80=99une relation professionnelle et s=E2=80=99op=C3=A8re=
nt dans cette seule finalit=C3=A9 et pour la dur=C3=A9e n=C3=A9cessaire =C3=
=A0 cette relation. Si vous souhaitez faire usage de vos droits de consulta=
tion, de rectification et de suppression de vos donn=C3=A9es, veuillez cont=
acter contact.rgpd@sgdsn.gouv.fr. Si vous avez re=C3=A7u ce message par err=
eur, nous vous remercions d=E2=80=99en informer l=E2=80=99exp=C3=A9diteur e=
t de d=C3=A9truire le message. The personal data collected and processed du=
ring this exchange aims solely at completing a business relationship and is=
 limited to the necessary duration of that relationship. If you wish to use=
 your rights of consultation, rectification and deletion of your data, plea=
se contact: contact.rgpd@sgdsn.gouv.fr. If you have received this message i=
n error, we thank you for informing the sender and destroying the message.
