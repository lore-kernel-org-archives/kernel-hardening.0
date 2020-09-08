Return-Path: <SRS0=gxmw=CR=lists.openwall.com=kernel-hardening-return-19807-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6621BC43461
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 13:30:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5233623C2D
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 13:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nX/01NNx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5233623C2D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19807-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5283 invoked by uid 550); 8 Sep 2020 13:30:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5257 invoked from network); 8 Sep 2020 13:30:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=jfLTOkb0DRyPqo4i4l2p3Sh7Mx8d6J0Yw6pAMOu9mVM=;
 b=nX/01NNxaa92Rl1Ego8qtBlBABFCgR8pOwh/ocMM0ry65QsBwr2XWMKftfg/am870VDp
 stVQ3SJxUP3f6yOobHXoROZmOPZAvEQ6eFZCX9AgIAwavmUq8wRdG5qn3QfY9MxB+8iI
 CV3QaH/gqz2IziqKcP7slNrUzQzCGepZgpp2yrOmLHAswCGz2GaNMVT/QcoXRUSj0vAV
 tuzek9sNCkYWH1LaSxRy8y3Qdx5QkMu3KE1RYbN7lVXw3Z1GGE1rYEKHuzmYJTsfZZ4k
 mj83KsuWDs7Reu1Y7W6uYU9Xf5amXHRNHilE6HXSRIColM6/3hHZbqX+srzr30PqAaUm fQ== 
Message-ID: <bdc10ab89cf9197e104f02a751009cf0d549ddf5.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v8 1/3] fs: Introduce AT_INTERPRETED flag for
 faccessat2(2)
From: Mimi Zohar <zohar@linux.ibm.com>
To: Stephen Smalley <stephen.smalley.work@gmail.com>,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?=
	 <mic@digikod.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Aleksa Sarai
 <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
        Al Viro
 <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy
 Lutomirski <luto@kernel.org>,
        Christian Brauner
 <christian.brauner@ubuntu.com>,
        Christian Heimes <christian@python.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Deven Bowers
 <deven.desai@linux.microsoft.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric
 Biggers <ebiggers@kernel.org>,
        Eric Chiang <ericchiang@google.com>,
        Florian
 Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>,
        Jan Kara
 <jack@suse.cz>, Jann Horn <jannh@google.com>,
        Jonathan Corbet
 <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
        Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>,
        Matthew Garrett
 <mjg59@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michael Kerrisk
 <mtk.manpages@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Philippe
 =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
        Scott Shell
 <scottsh@microsoft.com>,
        Sean Christopherson
 <sean.j.christopherson@intel.com>,
        Shuah Khan <shuah@kernel.org>, Steve
 Dower <steve.dower@python.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Tetsuo
 Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thibaut Sautereau
 <thibaut.sautereau@clip-os.org>,
        Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        LSM List
 <linux-security-module@vger.kernel.org>,
        Linux FS Devel
 <linux-fsdevel@vger.kernel.org>,
        Thibaut Sautereau
 <thibaut.sautereau@ssi.gouv.fr>,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?=
 <mic@linux.microsoft.com>,
        John Johansen <john.johansen@canonical.com>
Date: Tue, 08 Sep 2020 09:29:10 -0400
In-Reply-To: <CAEjxPJ6ZTKeunzJvWf_kS3QYjca6v1yJq=ad-jCCuDSgG6n60g@mail.gmail.com>
References: <20200908075956.1069018-1-mic@digikod.net>
	 <20200908075956.1069018-2-mic@digikod.net>
	 <d216615b48c093ebe9349a9dab3830b646575391.camel@linux.ibm.com>
	 <75451684-58f3-b946-dca4-4760fa0d7440@digikod.net>
	 <CAEjxPJ49_BgGX50ZAhHh79Qy3OMN6sssnUHT_2yXqdmgyt==9w@mail.gmail.com>
	 <CAEjxPJ6ZTKeunzJvWf_kS3QYjca6v1yJq=ad-jCCuDSgG6n60g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_06:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=866
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080123

On Tue, 2020-09-08 at 08:52 -0400, Stephen Smalley wrote:
> On Tue, Sep 8, 2020 at 8:50 AM Stephen Smalley
> <stephen.smalley.work@gmail.com> wrote:
> >
> > On Tue, Sep 8, 2020 at 8:43 AM Mickaël Salaün <mic@digikod.net> wrote:
> > >
> > >
> > > On 08/09/2020 14:28, Mimi Zohar wrote:
> > > > Hi Mickael,
> > > >
> > > > On Tue, 2020-09-08 at 09:59 +0200, Mickaël Salaün wrote:
> > > >> +                    mode |= MAY_INTERPRETED_EXEC;
> > > >> +                    /*
> > > >> +                     * For compatibility reasons, if the system-wide policy
> > > >> +                     * doesn't enforce file permission checks, then
> > > >> +                     * replaces the execute permission request with a read
> > > >> +                     * permission request.
> > > >> +                     */
> > > >> +                    mode &= ~MAY_EXEC;
> > > >> +                    /* To be executed *by* user space, files must be readable. */
> > > >> +                    mode |= MAY_READ;
> > > >
> > > > After this change, I'm wondering if it makes sense to add a call to
> > > > security_file_permission().  IMA doesn't currently define it, but
> > > > could.
> > >
> > > Yes, that's the idea. We could replace the following inode_permission()
> > > with file_permission(). I'm not sure how this will impact other LSMs though.

I wasn't suggesting replacing the existing security_inode_permission
hook later, but adding a new security_file_permission hook here.

> >
> > They are not equivalent at least as far as SELinux is concerned.
> > security_file_permission() was only to be used to revalidate
> > read/write permissions previously checked at file open to support
> > policy changes and file or process label changes.  We'd have to modify
> > the SELinux hook if we wanted to have it check execute access even if
> > nothing has changed since open time.
> 
> Also Smack doesn't appear to implement file_permission at all, so it
> would skip Smack checking.

My question is whether adding a new security_file_permission call here
would break either SELinux or Apparmor?

Mimi

