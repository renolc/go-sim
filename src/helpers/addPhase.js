import phase from '../game/phase'

import play from '../phases/play'
import mark from '../phases/mark'
import end from '../phases/end'

export default (state) => {
  switch(state.phase) {
    case phase.PLAY:
      const boundPlay = play(state)
      Object.keys(boundPlay).forEach((key) => state[key] = boundPlay[key])
      break

    case phase.MARK:
      const boundMark = mark(state)
      Object.keys(boundMark).forEach((key) => state[key] = boundMark[key])

    case phase.END:
      const boundEnd = end(state)
      Object.keys(boundEnd).forEach((key) => state[key] = boundEnd[key])
  }
}