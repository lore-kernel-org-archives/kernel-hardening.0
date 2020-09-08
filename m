Return-Path: <SRS0=4MXA=CR=lists.openwall.com=kernel-hardening-return-19803-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9EA3C43461
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 12:29:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C31862074D
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 12:29:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="V9k77lhW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C31862074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19803-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6087 invoked by uid 550); 8 Sep 2020 12:29:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6067 invoked from network); 8 Sep 2020 12:29:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=b2FT1Yp+l4dJYunaB80AnvbJt6l0uG5k65Skbsx6Sy8=;
 b=V9k77lhW3sb6csdZNpxIl9910mTpoiRoDp3MkEyld/e3fD02yY3g7sxiHE6/gzqLADC+
 Si+yZmClFZwJQqQNCKq8JAMFBokvbdMnISuehKADurb/l9JjG94mxWNvh0lDzzMq8fW+
 JLi4sbfAZz2qrDBW5U6Gclc/S0gRO4fiMBzMnLwsvMlMmo2G1vnFQcvUsTZse81XFv5O
 6eE0LjwIorjL7Zh62uo3d1btbdUld6I9gjsYhoYG3YI30Hwh49T8NUm5rJ0XmZLmUBuz
 5o7sB+/BBWEkHSJckKhWArL2nAqAnhKE6eLI9vE+A18yXbXhYeJp7sLz3ZdKQZCyZTyR Ag== 
Message-ID: <d216615b48c093ebe9349a9dab3830b646575391.camel@linux.ibm.com>
Subject: Re: [RFC PATCH v8 1/3] fs: Introduce AT_INTERPRETED flag for
 faccessat2(2)
From: Mimi Zohar <zohar@linux.ibm.com>
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        linux-kernel@vger.kernel.org
Cc: Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Christian
 Brauner <christian.brauner@ubuntu.com>,
        Christian Heimes
 <christian@python.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Deven
 Bowers <deven.desai@linux.microsoft.com>,
        Dmitry Vyukov
 <dvyukov@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Chiang
 <ericchiang@google.com>,
        Florian Weimer <fweimer@redhat.com>, James Morris
 <jmorris@namei.org>,
        Jan Kara <jack@suse.cz>, Jann Horn
 <jannh@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Kees Cook
 <keescook@chromium.org>,
        Lakshmi Ramasubramanian
 <nramas@linux.microsoft.com>,
        Matthew Garrett <mjg59@google.com>,
        Matthew
 Wilcox <willy@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Philippe =?ISO-8859-1?Q?Tr=E9buchet?=
 <philippe.trebuchet@ssi.gouv.fr>,
        Scott Shell <scottsh@microsoft.com>,
        Sean
 Christopherson <sean.j.christopherson@intel.com>,
        Shuah Khan
 <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
        Steve Grubb
 <sgrubb@redhat.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
        Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
        Stephen
 Smalley <stephen.smalley.work@gmail.com>,
        John Johansen
 <john.johansen@canonical.com>
Date: Tue, 08 Sep 2020 08:28:15 -0400
In-Reply-To: <20200908075956.1069018-2-mic@digikod.net>
References: <20200908075956.1069018-1-mic@digikod.net>
	 <20200908075956.1069018-2-mic@digikod.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_06:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 phishscore=0 mlxlogscore=725
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009080108

Hi Mickael,

On Tue, 2020-09-08 at 09:59 +0200, Mickaël Salaün wrote:
> diff --git a/fs/open.c b/fs/open.c
> index 9af548fb841b..879bdfbdc6fa 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -405,9 +405,13 @@ static long do_faccessat(int dfd, const char __user *filename, int mode, int fla
>  	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
>  		return -EINVAL;
>  
> -	if (flags & ~(AT_EACCESS | AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
> +	if (flags & ~(AT_EACCESS | AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH |
> +				AT_INTERPRETED))
>  		return -EINVAL;
>  
> +	/* Only allows X_OK with AT_INTERPRETED for now. */
> +	if ((flags & AT_INTERPRETED) && !(mode & S_IXOTH))
> +		return -EINVAL;
>  	if (flags & AT_SYMLINK_NOFOLLOW)
>  		lookup_flags &= ~LOOKUP_FOLLOW;
>  	if (flags & AT_EMPTY_PATH)
> @@ -426,7 +430,30 @@ static long do_faccessat(int dfd, const char __user *filename, int mode, int fla
>  
>  	inode = d_backing_inode(path.dentry);
>  
> -	if ((mode & MAY_EXEC) && S_ISREG(inode->i_mode)) {
> +	if ((flags & AT_INTERPRETED)) {
> +		/*
> +		 * For compatibility reasons, without a defined security policy
> +		 * (via sysctl or LSM), using AT_INTERPRETED must map the
> +		 * execute permission to the read permission.  Indeed, from
> +		 * user space point of view, being able to execute data (e.g.
> +		 * scripts) implies to be able to read this data.
> +		 *
> +		 * The MAY_INTERPRETED_EXEC bit is set to enable LSMs to add
> +		 * custom checks, while being compatible with current policies.
> +		 */
> +		if ((mode & MAY_EXEC)) {

Why is the ISREG() test being dropped?   Without dropping it, there
would be no reason for making the existing test an "else" clause.

> +			mode |= MAY_INTERPRETED_EXEC;
> +			/*
> +			 * For compatibility reasons, if the system-wide policy
> +			 * doesn't enforce file permission checks, then
> +			 * replaces the execute permission request with a read
> +			 * permission request.
> +			 */
> +			mode &= ~MAY_EXEC;
> +			/* To be executed *by* user space, files must be readable. */
> +			mode |= MAY_READ;

After this change, I'm wondering if it makes sense to add a call to
security_file_permission().  IMA doesn't currently define it, but
could.

Mimi

> +		}
> +	} else if ((mode & MAY_EXEC) && S_ISREG(inode->i_mode)) {
>  		/*
>  		 * MAY_EXEC on regular files is denied if the fs is mounted
>  		 * with the "noexec" flag.

