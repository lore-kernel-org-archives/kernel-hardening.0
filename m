References: <20170603055351.16080-1-matt@nmatt.com>
 <20170603154707.GA19161@openwall.com>
From: Matt Brown <matt@nmatt.com>
Message-ID: <f260f3fd-7fb7-7354-0830-204336004aca@nmatt.com>
Date: Mon, 5 Jun 2017 10:41:30 -0400
MIME-Version: 1.0
In-Reply-To: <20170603154707.GA19161@openwall.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v1 1/1] Add Trusted Path Execution as a
 stackable LSM
To: Solar Designer <solar@openwall.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 6/3/17 11:47 AM, Solar Designer wrote:
> Matt,
> 
> On Sat, Jun 03, 2017 at 01:53:51AM -0400, Matt Brown wrote:
>> This patch was modified from Brad Spengler's Trusted Path Execution (TPE)
>> feature in Grsecurity and also incorporates logging ideas from
>> cormander's tpe-lkm.
>>
>> Modifications from the Grsecurity implementation of TPE were made to
>> turn it into a stackable LSM using the existing LSM hook bprm_set_creds.
>> Also, denial messages were improved by including the full path of the
>> disallowed program. (This idea was taken from cormander's tpe-lkm)
>>
>> Trusted Path Execution is not a new idea:
>>
>> http://phrack.org/issues/52/6.html#article
> 
> FWIW, I think this is mostly a misfeature, which I deliberately didn't
> merge into -ow patches back then.
> 
>> This option enables Trusted Path Execution. TPE blocks *untrusted*
>> users from executing files that meet the following conditions:
>>
>> * file is not in a root-owned directory
>> * file is writable by a user other than root
>>
>> NOTE: root is never restricted by TPE
> 
>> Threat Models:
>>
>> 1. Attacker on system executing exploit on system vulnerability
>>
>> *  If attacker uses a binary as a part of their system exploit, TPE can
>>    frustrate their efforts
>>
>> *  Issues:
>>    *  Can be bypassed by interpreted languages such as python. You can run
>>       malicious code by doing: python -c 'evil code'
> 
> Yes, and not only that: a local attacker may also bypass TPE by what
> would have been non-security bugs in many other programs - e.g., a
> buffer overflow by a command-line argument in any of the allowed
> programs suddenly becomes security-relevant.
> 
> A variation of your threat model 1, which makes more sense to me than
> what's traditionally implied, is when the attacker does not yet use an
> interactive shell.  TPE can in fact frustrate automated remote exploits
> that don't specifically target (nor support) TPE-enabled systems.
> 
>> 2. Attacker on system replaces binary used by a privileged user with a
>>    malicious one
>>
>> *  This situation arises when administrator of a system leaves a binary
>>    as world writable.
>>
>> *  TPE is very effective against this threat model
> 
> This makes more sense to me.  It's known-bypassable policy enforcement
> by the sysadmin against one's own human error and such.  However, for
> this to be effective the exception "NOTE: root is never restricted by
> TPE" should be removed or made an option.

OK so a sysctl, kernel.tpe.restrict_root, that toggles if root is also
restricted? With this in mind I might rename restrict_all since that
might be confusing.

> 
> In a similar spirit, it'd also make sense to have a policy disallowing
> at least root to write into directories writable by other users without
> setting the O_EXCL flag.  I actually had this in a kernel module, which
> I used to find issues of this kind in Postfix in 2006 or so (Wietse
> promptly patched those), but I didn't try running this in production.
> 

Could you expand on what you think the threat model is for root not
writing into directories writable by other users? symlink issues?

> Summary: I see little value in TPE, but I don't intend to argue against
> it any further (and I deliberately dropped the CC list on this reply,
> not to hamper your efforts much).  If you choose to proceed with trying
> to upstream it anyway, I suggest the above changes to the description of
> the threat models and the tiny code change to allow for restricting root
> as well.
> 
> Thanks,
> 
> Alexander
> 
