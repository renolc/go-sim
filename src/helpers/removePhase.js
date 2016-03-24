import phase from '../game/phase'

import play from '../phases/play'
import mark from '../phases/mark'

export default (state) => {
  switch(state.phase) {
    case phase.PLAY:
      Object.keys(play(state)).forEach((key) => delete state[key])
      break

    case phase.MARK:
      Object.keys(mark(state)).forEach((key) => delete state[key])
  }
}