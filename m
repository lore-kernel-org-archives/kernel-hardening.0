Reply-To: kernel-hardening@lists.openwall.com
References: <bug-61313-391-meg9VHEJca@http.gcc.gnu.org/bugzilla/>
From: Jeff Law <law@redhat.com>
Message-ID: <564E0590.2050600@redhat.com>
Date: Thu, 19 Nov 2015 10:23:28 -0700
MIME-Version: 1.0
In-Reply-To: <bug-61313-391-meg9VHEJca@http.gcc.gnu.org/bugzilla/>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Fwd: [Bug lto/61313] configure incorrectly strips $target_alias from
 PLUGIN_LD_SUFFIX
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


And 24hrs after shunting the bug to the right guy, it's fixed :-)


-------- Forwarded Message --------
Subject: [Bug lto/61313] configure incorrectly strips $target_alias from 
PLUGIN_LD_SUFFIX
Date: Thu, 19 Nov 2015 13:34:45 +0000
From: ebotcazou at gcc dot gnu.org <gcc-bugzilla@gcc.gnu.org>
To: law@redhat.com

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61313

Eric Botcazou <ebotcazou at gcc dot gnu.org> changed:

            What    |Removed                     |Added
----------------------------------------------------------------------------
              Status|ASSIGNED                    |RESOLVED
          Resolution|---                         |FIXED
    Target Milestone|---                         |4.9.4

--- Comment #7 from Eric Botcazou <ebotcazou at gcc dot gnu.org> ---
Fixed everywhere.

-- 
You are receiving this mail because:
You are on the CC list for the bug.
