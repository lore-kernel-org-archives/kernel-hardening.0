Return-Path: <SRS0=/Osa=V5=lists.openwall.com=kernel-hardening-return-16687-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7420C19759
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 17:35:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 189A22087E
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 17:35:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBSjLTF2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 189A22087E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16687-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32753 invoked by uid 550); 1 Aug 2019 17:35:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32720 invoked from network); 1 Aug 2019 17:35:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=cmtOeJgUg1mSCwNm5Vv4F5lxhgDIyj0LXvGIj3jOCDo=;
        b=cBSjLTF2IQo34tFeZp7/IqR8VhIt+1dXBxPWecfXJqSnP2DwW+enMoLtI62r3LrTM6
         RJNIpu4wOEW3iwm9pRZ7TgHxAwqQ0tqOd00fV4NvMa/BXCjtoziu3jtaKZDjmc9OaDet
         Vt0Q8Au7e+5Dcv0Z8pPhTXv8Ks/KNeyDx+RLGbcww7Z8dChPiYAGpmO+0OKB7W1lxQX8
         dqP4QOxJQUEuYiQYED5LNY/5PHyo1ZMPZao90anVisdMkFVLGN3ufVjSOn0LzERAQRGs
         2nbCICF+U6ugts750bn90UPiDhdaz0Qyotg5/se/FHHxvjlDncBrKFcNRadMbwlnm1JD
         S1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=cmtOeJgUg1mSCwNm5Vv4F5lxhgDIyj0LXvGIj3jOCDo=;
        b=F/0ZZRz0x05TwKgQtMUjPIUqomXMDIJWg9+1JiZGPlLNlNJG4LbeG8/rSiU1riDJJN
         jYH4Zf9NvfaRfWUuPPfm8zsQ6ESlJ2sm0f6YWWg/4nEGIUfi+4f8TCLN3NTMX9LgMEkp
         q24fF+tT5CrDa8yrmrvpglrlI7hvSnhNiUNn7YQ34rAfczpg2Z4+IYoMqkYHHnijG0th
         8iv1J97luwING4tY6StMuFk/oW7/5QXYKNHiqEK0d8Rb1+lAI7VCjYxpH77crXc2Sm17
         C7s6L9J1PUD3PfTpR05lBMyu2HtIgRQEP+y+rH+6ZTpBiq1WvjOXKGkzmZZBlu1xHm7c
         WcNQ==
X-Gm-Message-State: APjAAAXgBjg2pFsXXkiLprtqjLVR7BuKZAXGYCFl/1qwZisMFc3xrskl
	MwhBQHdN24wtrteTxNx9nT0=
X-Google-Smtp-Source: APXvYqzI3/bdzyfwxz0PsvQhshGMsCzZlPOo9cdI9g9+T6qhAyPP0PsvTtGvkAuBeX3ygym6rsavSw==
X-Received: by 2002:a62:1ac9:: with SMTP id a192mr14756335pfa.260.1564680939408;
        Thu, 01 Aug 2019 10:35:39 -0700 (PDT)
Date: Thu, 1 Aug 2019 10:35:36 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Drysdale <drysdale@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>,
	Tejun Heo <tj@kernel.org>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
	Will Drewry <wad@chromium.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
	LSM List <linux-security-module@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v10 06/10] bpf,landlock: Add a new map type:
 inode
Message-ID: <20190801173534.etfls5ltixp5hfrh@ast-mbp.dhcp.thefacebook.com>
References: <20190721213116.23476-1-mic@digikod.net>
 <20190721213116.23476-7-mic@digikod.net>
 <20190727014048.3czy3n2hi6hfdy3m@ast-mbp.dhcp.thefacebook.com>
 <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
 <CAADnVQLqkfVijWoOM29PxCL_yK6K0fr8B89r4c5EKgddevJhGQ@mail.gmail.com>
 <59e8fab9-34df-0ebe-ca6b-8b34bf582b75@ssi.gouv.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <59e8fab9-34df-0ebe-ca6b-8b34bf582b75@ssi.gouv.fr>
User-Agent: NeoMutt/20180223

On Wed, Jul 31, 2019 at 09:11:10PM +0200, Mickaël Salaün wrote:
> 
> 
> On 31/07/2019 20:58, Alexei Starovoitov wrote:
> > On Wed, Jul 31, 2019 at 11:46 AM Mickaël Salaün
> > <mickael.salaun@ssi.gouv.fr> wrote:
> >>>> +    for (i = 0; i < htab->n_buckets; i++) {
> >>>> +            head = select_bucket(htab, i);
> >>>> +            hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
> >>>> +                    landlock_inode_remove_map(*((struct inode **)l->key), map);
> >>>> +            }
> >>>> +    }
> >>>> +    htab_map_free(map);
> >>>> +}
> >>>
> >>> user space can delete the map.
> >>> that will trigger inode_htab_map_free() which will call
> >>> landlock_inode_remove_map().
> >>> which will simply itereate the list and delete from the list.
> >>
> >> landlock_inode_remove_map() removes the reference to the map (being
> >> freed) from the inode (with an RCU lock).
> >
> > I'm going to ignore everything else for now and focus only on this bit,
> > since it's fundamental issue to address before this discussion can
> > go any further.
> > rcu_lock is not a spin_lock. I'm pretty sure you know this.
> > But you're arguing that it's somehow protecting from the race
> > I mentioned above?
> >
> 
> I was just clarifying your comment to avoid misunderstanding about what
> is being removed.
> 
> As said in the full response, there is currently a race but, if I add a
> bpf_map_inc() call when the map is referenced by inode->security, then I
> don't see how a race could occur because such added map could only be
> freed in a security_inode_free() (as long as it retains a reference to
> this inode).

then it will be a cycle and a map will never be deleted?
closing map_fd should delete a map. It cannot be alive if it's not
pinned in bpffs, there are no FDs that are holding it, and no progs using it.
So the map deletion will iterate over inodes that belong to this map.
In parallel security_inode_free() will be called that will iterate
over its link list that contains elements from different maps.
So the same link list is modified by two cpus.
Where is a lock that protects from concurrent links list manipulations?

> Les données à caractère personnel recueillies et traitées dans le cadre de cet échange, le sont à seule fin d’exécution d’une relation professionnelle et s’opèrent dans cette seule finalité et pour la durée nécessaire à cette relation. Si vous souhaitez faire usage de vos droits de consultation, de rectification et de suppression de vos données, veuillez contacter contact.rgpd@sgdsn.gouv.fr. Si vous avez reçu ce message par erreur, nous vous remercions d’en informer l’expéditeur et de détruire le message. The personal data collected and processed during this exchange aims solely at completing a business relationship and is limited to the necessary duration of that relationship. If you wish to use your rights of consultation, rectification and deletion of your data, please contact: contact.rgpd@sgdsn.gouv.fr. If you have received this message in error, we thank you for informing the sender and destroying the message.

Please get rid of this. It's absolutely not appropriate on public mailing list.
Next time I'd have to ignore emails that contain such disclaimers.

