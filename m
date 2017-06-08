Date: Thu, 8 Jun 2017 23:18:17 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170608211817.GA31010@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] hard link restrictions
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Kees, all -

My renewed interest in hard link restrictions was in context of crontab
vs. crond privsep:

http://www.openwall.com/lists/oss-security/2017/06/08/3

Under that threat model (mostly overlooked/neglected so far?), any
hard link to another user's (or root's) file is risky.  Even a file the
linking user could readily read and write.  For crond specifically, this
is not the case because it will refuse to process files with extra write
permissions.  But for other services not yet hardened like this, e.g.
mode 666 files hard-linked into their queue, etc. directories could be
usable for attacks.

Another subtle scenario where a hard link to another user's writable
file could help the attacker is preserving one's ability to bypass disk
quota via that file, even after the original owner would have deleted
their original link to the file.  Similarly, it'd allow for keeping the
other user's disk quota consumption even until after that user would
have deleted their original link and wanted the quota usage reclaimed.

Because those hard link restrictions were so non-standard back
when they were new, we applied them only to files the user could not
readily read and write, plus to SUIDs/SGIDs for the "pinning" concern.
We tried to minimize breakage of programs relying on being able to hard
link to arbitrary files.

Maybe now is the time to introduce a stricter mode, perhaps enabled with
"fs.protected_hardlinks = 2", where any hard links to other users' files
would be disallowed, except when the invoking process has CAP_FOWNER?

In code, this would be skipping the "|| safe_hardlink_source(inode)" in:

	/* Source inode owner (or CAP_FOWNER) can hardlink all they like,
	 * otherwise, it must be a safe source.
	 */
	if (inode_owner_or_capable(inode) || safe_hardlink_source(inode))
		return 0;

While we're at it, doesn't the above code unnecessarily set PF_SUPERPRIV
(which is then reported via BSD process accounting) when the CAP_FOWNER
check inside inode_owner_or_capable() is reached and passed, but
safe_hardlink_source() later returns false?

In fact, inode_owner_or_capable() itself might also be problematic in
this respect in that it'd set PF_SUPERPRIV even if kuid_has_mapping()
later fails:

        if (ns_capable(ns, CAP_FOWNER) && kuid_has_mapping(ns, inode->i_uid))
                return true;

Or has the kernel gave up on being careful not to set PF_SUPERPRIV
unnecessarily?  Sometimes it's a conflicting goal to minimizing the
attack surface and improving performance in case of request flood DoS
attacks, where it's best to stop processing the request sooner ("you
would not be capable anyway") than later (after expensive other checks).

Alexander
