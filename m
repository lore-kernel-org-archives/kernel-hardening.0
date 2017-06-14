Date: Wed, 14 Jun 2017 15:10:08 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20170614151008.42bc57a2@alans-desktop>
In-Reply-To: <1497277644.21594.319.camel@linux.vnet.ibm.com>
References: <201706100041.GFH78616.OFtOHFJSLQOMVF@I-love.SAKURA.ne.jp>
	<754b78d1-f7f9-58bd-bf74-fea9e105649a@nmatt.com>
	<20170609164315.GA1141@meriadoc.perfinion.com>
	<d84aaf19-307b-4b60-df74-4fb43a218c9c@nmatt.com>
	<CAGXu5jJt5MRU3ZdKABEbLt4qe-cCLxEm5tMH9SdUh=rtdLUV1w@mail.gmail.com>
	<201706101427.EEG90168.OtFFHSFMOVOJQL@I-love.SAKURA.ne.jp>
	<d9aca46b-97c6-4faf-b559-484feb4aa640@digikod.net>
	<1497234757.21594.280.camel@linux.vnet.ibm.com>
	<1497277644.21594.319.camel@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v1] shebang: restrict python interactive
 prompt/interpreter
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, keescook@chromium.org, matt@nmatt.com, jason@perfinion.com, linux-security-module@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>, kernel-hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 12 Jun 2017 10:27:24 -0400
Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> On Sun, 2017-06-11 at 22:32 -0400, Mimi Zohar wrote:
> > On Sun, 2017-06-11 at 13:44 +0200, Micka=C3=ABl Sala=C3=BCn wrote: =20
> =20
> > > Using filesystem xattr seems like a good idea for this kind of
> > > exceptions and instead of a hardcoded interpreter path. Something like
> > > "security.tpe.interpreter=3D1|2" (bitmask for interpreter-only and/or=
 CLI)
> > > and "security.tpe.environment=3DHOME,LOGNAME" would be quite flexible=
 to
> > > configure a security policy for some binaries. This could also be
> > > protected by IMA/EVM, if needed. =20
> >=20
> > Checking for the existence of an xattr without caching is relatively
> > slow. =C2=A0I'm not sure that we would want to go this route. =20
> =C2=A0
> For identifying interpreters, xattrs would be too slow (without
> caching results), but once identified, using xattrs as you suggested,
> for specifying how interpreters can be invoked and limiting
> environment variables, is a good idea. =C2=A0Perhaps the two xattrs could
> be combined?

It's not just #! you need to cover. If I can run ld.so for my arch format
then ld.so will helpfully let me load any ELF binary I like and run it.

Alan
