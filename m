From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Mon, 12 Jun 2017 10:27:24 -0400
In-Reply-To: <1497234757.21594.280.camel@linux.vnet.ibm.com>
References: <201706100041.GFH78616.OFtOHFJSLQOMVF@I-love.SAKURA.ne.jp>
	 <754b78d1-f7f9-58bd-bf74-fea9e105649a@nmatt.com>
	 <20170609164315.GA1141@meriadoc.perfinion.com>
	 <d84aaf19-307b-4b60-df74-4fb43a218c9c@nmatt.com>
	 <CAGXu5jJt5MRU3ZdKABEbLt4qe-cCLxEm5tMH9SdUh=rtdLUV1w@mail.gmail.com>
	 <201706101427.EEG90168.OtFFHSFMOVOJQL@I-love.SAKURA.ne.jp>
	 <d9aca46b-97c6-4faf-b559-484feb4aa640@digikod.net>
	 <1497234757.21594.280.camel@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1497277644.21594.319.camel@linux.vnet.ibm.com>
Subject: [kernel-hardening] Re: [PATCH v1] shebang: restrict python interactive
 prompt/interpreter
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, keescook@chromium.org, matt@nmatt.com
Cc: jason@perfinion.com, linux-security-module@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>, kernel-hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 2017-06-11 at 22:32 -0400, Mimi Zohar wrote:
> On Sun, 2017-06-11 at 13:44 +0200, Mickaël Salaün wrote:
 
> > Using filesystem xattr seems like a good idea for this kind of
> > exceptions and instead of a hardcoded interpreter path. Something like
> > "security.tpe.interpreter=1|2" (bitmask for interpreter-only and/or CLI)
> > and "security.tpe.environment=HOME,LOGNAME" would be quite flexible to
> > configure a security policy for some binaries. This could also be
> > protected by IMA/EVM, if needed.
> 
> Checking for the existence of an xattr without caching is relatively
> slow.  I'm not sure that we would want to go this route.
 
For identifying interpreters, xattrs would be too slow (without
caching results), but once identified, using xattrs as you suggested,
for specifying how interpreters can be invoked and limiting
environment variables, is a good idea.  Perhaps the two xattrs could
be combined?

Mimi
