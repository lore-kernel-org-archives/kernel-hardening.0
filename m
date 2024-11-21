Return-Path: <kernel-hardening-return-21872-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 8F745E64010
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 Nov 2024 20:35:53 +0000 (UTC)
Received: (qmail 16151 invoked by uid 550); 21 Nov 2024 20:35:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16098 invoked from network); 21 Nov 2024 20:35:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rlelLu
	NxaQbOjS+AkBlNiz3aAj7rJ3O71jw+IWqCHcY=; b=FLFIZr1rr1BmrgPgUxiG3g
	Sn9cNjYHRsSVYuOrafvD0Oas8M5sJR3icX2DR4H+Ij8pW1K/nJ1dQ80N/VTGAfJb
	gUzKG2pWPH6ZwcS7EP/V5A85Z803GnU1c+1Pj0XfDxOkcnQU020QCLahQT6i/1Ee
	anToxEuakKvgsE2qEjn6OwHJRSEGLWzplZjyqgcyR2KALhJ6iuST4Ap9niIrbXek
	lmSmFnHLYvZxf1hDcNh3nvmSH52GrdPBsfQ2FxMXHw5I/46RlnCZt2b3PBSYYnkh
	WU2kJJDaY/8gGcEnFFq9zO4Zjz7tEFINhYu22GZYGE5uf9G8uY71LM5QXTQvt1xw
	==
Message-ID: <d115a20889d01bc7b12dbd8cf99aad0be58cbc97.camel@linux.ibm.com>
Subject: Re: [PATCH v21 6/6] samples/check-exec: Add an enlighten "inc"
 interpreter and 28 tests
From: Mimi Zohar <zohar@linux.ibm.com>
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        Al Viro
 <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Kees
 Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>,
        Serge
 Hallyn <serge@hallyn.com>
Cc: Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Alejandro
 Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>, Arnd
 Bergmann <arnd@arndb.de>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Christian Heimes <christian@python.org>,
        Dmitry Vyukov
 <dvyukov@google.com>, Elliott Hughes <enh@google.com>,
        Eric Biggers
 <ebiggers@kernel.org>,
        Eric Chiang <ericchiang@google.com>,
        Fan Wu
 <wufan@linux.microsoft.com>,
        Florian Weimer <fweimer@redhat.com>,
        Geert
 Uytterhoeven <geert@linux-m68k.org>,
        James Morris
 <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>,
        Jann Horn
 <jannh@google.com>, Jeff Xu <jeffxu@google.com>,
        Jonathan Corbet
 <corbet@lwn.net>,
        Jordan R Abrahams <ajordanr@google.com>,
        Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>,
        Linus Torvalds
 <torvalds@linux-foundation.org>,
        Luca Boccassi <bluca@debian.org>,
        Luis
 Chamberlain <mcgrof@kernel.org>,
        "Madhavan T . Venkataraman"
 <madvenka@linux.microsoft.com>,
        Matt Bobrowski <mattbobrowski@google.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matthew Wilcox
 <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Nicolas
 Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
        Scott Shell
 <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
        Stephen Rothwell
 <sfr@canb.auug.org.au>,
        Steve Dower <steve.dower@python.org>, Steve Grubb
 <sgrubb@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Thibaut Sautereau
 <thibaut.sautereau@ssi.gouv.fr>,
        Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        Yin
 Fengwei <fengwei.yin@intel.com>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Date: Thu, 21 Nov 2024 15:34:47 -0500
In-Reply-To: <20241112191858.162021-7-mic@digikod.net>
References: <20241112191858.162021-1-mic@digikod.net>
	 <20241112191858.162021-7-mic@digikod.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5j4NljDjvOK_TMG_-0z2jGGIPzeoKdQE
X-Proofpoint-ORIG-GUID: y_4dWfxzFvg9Bphre9Ic1A5QOC1Kd_4I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 adultscore=0 mlxlogscore=977 mlxscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411210153

Hi Micka=C3=ABl,

On Tue, 2024-11-12 at 20:18 +0100, Micka=C3=ABl Sala=C3=BCn wrote:
>=20
> +
> +/* Returns 1 on error, 0 otherwise. */
> +static int interpret_stream(FILE *script, char *const script_name,
> +			    char *const *const envp, const bool restrict_stream)
> +{
> +	int err;
> +	char *const script_argv[] =3D { script_name, NULL };
> +	char buf[128] =3D {};
> +	size_t buf_size =3D sizeof(buf);
> +
> +	/*
> +	 * We pass a valid argv and envp to the kernel to emulate a native
> +	 * script execution.  We must use the script file descriptor instead of
> +	 * the script path name to avoid race conditions.
> +	 */
> +	err =3D execveat(fileno(script), "", script_argv, envp,
> +		       AT_EMPTY_PATH | AT_EXECVE_CHECK);

At least with v20, the AT_CHECK always was being set, independent of whethe=
r
set-exec.c set it.  I'll re-test with v21.

thanks,

Mimi

> +	if (err && restrict_stream) {
> +		perror("ERROR: Script execution check");
> +		return 1;
> +	}
> +
> +	/* Reads script. */
> +	buf_size =3D fread(buf, 1, buf_size - 1, script);
> +	return interpret_buffer(buf, buf_size);
> +}
> +

