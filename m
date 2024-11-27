Return-Path: <kernel-hardening-return-21880-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 11861D6ACE8
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2024 15:16:03 +0000 (UTC)
Received: (qmail 9506 invoked by uid 550); 27 Nov 2024 15:15:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9480 invoked from network); 27 Nov 2024 15:15:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=GCS2DQ
	Uac3TMxyLYLwiZmv8x54wgn5Xk1pl4/F6v0m0=; b=iqIzHT3enT0CDH3A46gu9i
	EZdykzNoAwSOXOa8g6bp5tEcZ5ODbWqx/tvnX/bE62xurMdnL9iYj9BKi4sFZUyb
	bF++yjbC6KQqTbuw4Z9l017b3SqIYljh8Pg/4zb/FYOiRZWPC+O5eiiPxM+x5pi8
	SYULlPbc6i9CHHMtwogs56NIe2vgPimoh56yFuhzVuIVT2tYIDYmcljzldGnRmRj
	f7si3zFqf+YJI0YhqAdYXo87LRjEw/bYVEnwJtLzKB4vYQBe7wkOU5DtI9fCx1G0
	Q5euZ+ZkncA1NGmTxCpghOmr4S9XknE3vv7narDXXtcttxpFFowjef4YTd6YAB8A
	==
Message-ID: <a566be590766eac5811a1e44af5cfd731d503d7e.camel@linux.ibm.com>
Subject: Re: [PATCH v21 6/6] samples/check-exec: Add an enlighten "inc"
 interpreter and 28 tests
From: Mimi Zohar <zohar@linux.ibm.com>
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>,
        Kees Cook <keescook@chromium.org>, Paul Moore
 <paul@paul-moore.com>,
        Serge Hallyn <serge@hallyn.com>,
        Adhemerval Zanella
 Netto <adhemerval.zanella@linaro.org>,
        Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>,
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
Date: Wed, 27 Nov 2024 10:15:00 -0500
In-Reply-To: <20241127.Ob8DaeR9xaul@digikod.net>
References: <20241112191858.162021-1-mic@digikod.net>
	 <20241112191858.162021-7-mic@digikod.net>
	 <d115a20889d01bc7b12dbd8cf99aad0be58cbc97.camel@linux.ibm.com>
	 <20241122.ahY1pooz1ing@digikod.net>
	 <623f89b4de41ac14e0e48e106b846abc9e9d70cf.camel@linux.ibm.com>
	 <20241127.Ob8DaeR9xaul@digikod.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Kd8WuLouAhuXRPFpDaVk4_8ACYrn9rDN
X-Proofpoint-ORIG-GUID: 0WhnWlE6pkwgsa_A3gcl6aVmeAxdV_mA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411270119

On Wed, 2024-11-27 at 13:10 +0100, Micka=C3=ABl Sala=C3=BCn wrote:
> On Tue, Nov 26, 2024 at 12:41:45PM -0500, Mimi Zohar wrote:
> > On Fri, 2024-11-22 at 15:50 +0100, Micka=C3=ABl Sala=C3=BCn wrote:
> > > On Thu, Nov 21, 2024 at 03:34:47PM -0500, Mimi Zohar wrote:
> > > > Hi Micka=C3=ABl,
> > > >=20
> > > > On Tue, 2024-11-12 at 20:18 +0100, Micka=C3=ABl Sala=C3=BCn wrote:
> > > > >=20
> > > > > +
> > > > > +/* Returns 1 on error, 0 otherwise. */
> > > > > +static int interpret_stream(FILE *script, char *const script_nam=
e,
> > > > > +			    char *const *const envp, const bool restrict_stream)
> > > > > +{
> > > > > +	int err;
> > > > > +	char *const script_argv[] =3D { script_name, NULL };
> > > > > +	char buf[128] =3D {};
> > > > > +	size_t buf_size =3D sizeof(buf);
> > > > > +
> > > > > +	/*
> > > > > +	 * We pass a valid argv and envp to the kernel to emulate a nat=
ive
> > > > > +	 * script execution.  We must use the script file descriptor in=
stead of
> > > > > +	 * the script path name to avoid race conditions.
> > > > > +	 */
> > > > > +	err =3D execveat(fileno(script), "", script_argv, envp,
> > > > > +		       AT_EMPTY_PATH | AT_EXECVE_CHECK);
> > > >=20
> > > > At least with v20, the AT_CHECK always was being set, independent o=
f whether
> > > > set-exec.c set it.  I'll re-test with v21.
> > >=20
> > > AT_EXECVE_CEHCK should always be set, only the interpretation of the
> > > result should be relative to securebits.  This is highlighted in the
> > > documentation.
> >=20
> > Sure, that sounds correct.  With an IMA-appraisal policy, any unsigned =
script
> > with the is_check flag set now emits an "cause=3DIMA-signature-required=
" audit
> > message.  However since IMA-appraisal isn't enforcing file signatures, =
this
> > sounds wrong.
> >=20
> > New audit messages like "IMA-signature-required-by-interpreter" and "IM=
A-
> > signature-not-required-by-interpreter" would need to be defined based o=
n the
> > SECBIT_EXEC_RESTRICT_FILE.
>=20
> It makes sense.  Could you please send a patch for these
> IMA-*-interpreter changes?  I'll include it in the next series.

Sent as an RFC.  The audit message is only updated for the missing signatur=
e
case.  However, all of the audit messages in ima_appraise_measurement() sho=
uld
be updated.  The current method doesn't scale.

Mimi

> >=20
> >=20
> > > >=20
> > > > > +	if (err && restrict_stream) {
> > > > > +		perror("ERROR: Script execution check");
> > > > > +		return 1;
> > > > > +	}
> > > > > +
> > > > > +	/* Reads script. */
> > > > > +	buf_size =3D fread(buf, 1, buf_size - 1, script);
> > > > > +	return interpret_buffer(buf, buf_size);
> > > > > +}
> > > > > +
> > > >=20
> > > >=20
> > >=20
> >=20
> >=20
>=20

