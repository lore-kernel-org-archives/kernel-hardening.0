Return-Path: <kernel-hardening-return-21878-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 2CD9AD6ACC3
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Nov 2024 12:10:21 +0000 (UTC)
Received: (qmail 16052 invoked by uid 550); 27 Nov 2024 12:10:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16030 invoked from network); 27 Nov 2024 12:10:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1732709404;
	bh=eaKW65KI9A4QWlkoj9p8ZqojNDFsLmXT/WQoZnFsFi4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=z1nDNSfDg8/hBzUqX3ND2eBcdGPY0I9VFQ7uecWNWsXIjKccfI9h5bzk/YwjONaUY
	 F6ZVNzQLzkfp8vDEcetAyqgAdma7/LWhN950mzLoaG/ViuhXt0nFJUuAuvOCupiWmr
	 2456DcNFx8quafajuekQEQoGZa5dDLRuchrtSIFk=
Date: Wed, 27 Nov 2024 13:10:01 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <serge@hallyn.com>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, Alejandro Colomar <alx@kernel.org>, 
	Aleksa Sarai <cyphar@cyphar.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Elliott Hughes <enh@google.com>, 
	Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>, 
	Fan Wu <wufan@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jamorris@linux.microsoft.com>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Luca Boccassi <bluca@debian.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Steve Dower <steve.dower@python.org>, 
	Steve Grubb <sgrubb@redhat.com>, Theodore Ts'o <tytso@mit.edu>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, 
	Xiaoming Ni <nixiaoming@huawei.com>, Yin Fengwei <fengwei.yin@intel.com>, 
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v21 6/6] samples/check-exec: Add an enlighten "inc"
 interpreter and 28 tests
Message-ID: <20241127.Ob8DaeR9xaul@digikod.net>
References: <20241112191858.162021-1-mic@digikod.net>
 <20241112191858.162021-7-mic@digikod.net>
 <d115a20889d01bc7b12dbd8cf99aad0be58cbc97.camel@linux.ibm.com>
 <20241122.ahY1pooz1ing@digikod.net>
 <623f89b4de41ac14e0e48e106b846abc9e9d70cf.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <623f89b4de41ac14e0e48e106b846abc9e9d70cf.camel@linux.ibm.com>
X-Infomaniak-Routing: alpha

On Tue, Nov 26, 2024 at 12:41:45PM -0500, Mimi Zohar wrote:
> On Fri, 2024-11-22 at 15:50 +0100, Mickaël Salaün wrote:
> > On Thu, Nov 21, 2024 at 03:34:47PM -0500, Mimi Zohar wrote:
> > > Hi Mickaël,
> > > 
> > > On Tue, 2024-11-12 at 20:18 +0100, Mickaël Salaün wrote:
> > > > 
> > > > +
> > > > +/* Returns 1 on error, 0 otherwise. */
> > > > +static int interpret_stream(FILE *script, char *const script_name,
> > > > +			    char *const *const envp, const bool restrict_stream)
> > > > +{
> > > > +	int err;
> > > > +	char *const script_argv[] = { script_name, NULL };
> > > > +	char buf[128] = {};
> > > > +	size_t buf_size = sizeof(buf);
> > > > +
> > > > +	/*
> > > > +	 * We pass a valid argv and envp to the kernel to emulate a native
> > > > +	 * script execution.  We must use the script file descriptor instead of
> > > > +	 * the script path name to avoid race conditions.
> > > > +	 */
> > > > +	err = execveat(fileno(script), "", script_argv, envp,
> > > > +		       AT_EMPTY_PATH | AT_EXECVE_CHECK);
> > > 
> > > At least with v20, the AT_CHECK always was being set, independent of whether
> > > set-exec.c set it.  I'll re-test with v21.
> > 
> > AT_EXECVE_CEHCK should always be set, only the interpretation of the
> > result should be relative to securebits.  This is highlighted in the
> > documentation.
> 
> Sure, that sounds correct.  With an IMA-appraisal policy, any unsigned script
> with the is_check flag set now emits an "cause=IMA-signature-required" audit
> message.  However since IMA-appraisal isn't enforcing file signatures, this
> sounds wrong.
> 
> New audit messages like "IMA-signature-required-by-interpreter" and "IMA-
> signature-not-required-by-interpreter" would need to be defined based on the
> SECBIT_EXEC_RESTRICT_FILE.

It makes sense.  Could you please send a patch for these
IMA-*-interpreter changes?  I'll include it in the next series.

> 
> 
> > > 
> > > > +	if (err && restrict_stream) {
> > > > +		perror("ERROR: Script execution check");
> > > > +		return 1;
> > > > +	}
> > > > +
> > > > +	/* Reads script. */
> > > > +	buf_size = fread(buf, 1, buf_size - 1, script);
> > > > +	return interpret_buffer(buf, buf_size);
> > > > +}
> > > > +
> > > 
> > > 
> > 
> 
> 
