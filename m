Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <52578A4D.2000300@gmail.com>
Date: Fri, 11 Oct 2013 16:19:09 +1100
From: Ryan Mallon <rmallon@gmail.com>
MIME-Version: 1.0
References: <20131011044232.11545.qmail@science.horizon.com>
In-Reply-To: <20131011044232.11545.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
To: George Spelvin <linux@horizon.com>, ebiederm@xmission.com, joe@perches.com
Cc: akpm@linux-foundation.org, dan.j.rosenberg@gmail.com, eldad@fogrefinery.com, jgunthorpe@obsidianresearch.com, jkosina@suse.cz, keescook@chromium.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
List-ID: <kernel-hardening.lists.openwall.com>

On 11/10/13 15:42, George Spelvin wrote:
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>> Sigh.  This is all wrong.  The only correct thing to test is
>> file->f_cred.  Aka the capabilities of the program that opened the
>> file.
>>
>> Which means that the interface to %pK in the case of kptr_restrict is
>> broken as it has no way to be passed the information it needs to make
>> a sensible decision.
> 
> I looked at the code, and pretty painful.  Certainly it's possible to
> include a reference to the file (I was thinking of just the credentials,
> actually) in the seq_file.  But getting that to the vsprintf.c code
> (specifically, the pointer() function) is a PITA.
> 
> I'm willing to accept the currently proposed kludge as a "good enough"
> approximation, as long as we're all agreed that using the credentials
> at open() time would be The Right Thing, and hopefully someone will find
> the round tuitts to implement that in future.
> 
> But in the meantime, "the perfect is the enemey of the good" is worth
> remembering.
> 
> (An alternate implementation I've been thinking about would be to do
> away with %pK, and instead have a "secret_ptr(p, seq->cred)" helper that
> returned p or 0 depending on the credential.)

Yeah, that is probably the best solution. I'll try to put together a
patch series doing this. It will obviously be more involved though, so I
think it is still worth merging the original patch in the interm.

~Ryan
