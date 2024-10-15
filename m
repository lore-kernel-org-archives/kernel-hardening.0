Return-Path: <kernel-hardening-return-21846-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id C0420D216A2
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Oct 2024 13:25:04 +0000 (UTC)
Received: (qmail 9790 invoked by uid 550); 15 Oct 2024 13:24:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17858 invoked from network); 15 Oct 2024 03:21:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728962468;
	bh=6GU14EHAskdr4mkFX20oaALVO6IMc8fAdjuAO4mVF74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tIqoFCu3sCLdSPCkyuHRyP8tYwfelfi0NJNWhErYSrWlp3q7YI8ncg483C+nIsX/s
	 Q0vzBy2JNDb9aIE4chnaSzJrPBJ9T/CyeQYt+G9NXQbe5kf8jvcaT71aIhpy911ydD
	 3LcOGuF8622H9E3MVs3MrRA01cB+kHrV0szgmmdNdpKv05Q13eqdUFl9PukN0eoqbp
	 WpOmfYJxc8HI604DZcc+suQ0RCgzpkdOvrf3c+Nkf6eq0drI33SBlXr7f6U8sw0zGI
	 wLC/SFW1Msw3NfB+8VHpuswOLwOla0ehBGX9J647WP64G3+81LFEQanuqa0WLoD5CV
	 +6uJP56Tt32fw==
Date: Tue, 15 Oct 2024 03:20:55 +0000
From: sergeh@kernel.org
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Alejandro Colomar <alx@kernel.org>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Heimes <christian@python.org>,
	Dmitry Vyukov <dvyukov@google.com>, Elliott Hughes <enh@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Fan Wu <wufan@linux.microsoft.com>,
	Florian Weimer <fweimer@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	James Morris <jamorris@linux.microsoft.com>,
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Jordan R Abrahams <ajordanr@google.com>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Luca Boccassi <bluca@debian.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	Xiaoming Ni <nixiaoming@huawei.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v20 1/6] exec: Add a new AT_CHECK flag to execveat(2)
Message-ID: <Zw3fl8OihgUay_53@lei>
References: <20241011184422.977903-1-mic@digikod.net>
 <20241011184422.977903-2-mic@digikod.net>
 <20241013030416.GA1056921@mail.hallyn.com>
 <20241014.ke5eeKoo6doh@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241014.ke5eeKoo6doh@digikod.net>

On Mon, Oct 14, 2024 at 09:39:52AM +0200, Mickaël Salaün wrote:
> On Sat, Oct 12, 2024 at 10:04:16PM -0500, Serge E. Hallyn wrote:
> > On Fri, Oct 11, 2024 at 08:44:17PM +0200, Mickaël Salaün wrote:
> > > Add a new AT_CHECK flag to execveat(2) to check if a file would be
> > 
> > Apologies for both bikeshedding and missing earlier discussions.
> > 
> > But AT_CHECK sounds quite generic.  How about AT_EXEC_CHECK, or
> > AT_CHECK_EXEC_CREDS?  (I would suggest just AT_CHECK_CREDS since
> > it's for use in execveat(2), but as it's an AT_ flag, it's
> > probably worth being more precise).
> 
> As Amir pointed out, we need at least to use the AT_EXECVE_CHECK_
> prefix, and I agree with the AT_EXECVE_CHECK name because it's about
> checking the whole execve request, not sepcifically a "creds" part.

Well, not the whole.  You are explicitly not checking the validity of the
files.

But ok.  With that,

Reviewed-by: Serge Hallyn <sergeh@kernel.org>

thanks,
-serge
